
//
//  SpeeachRecognizerManager.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/27/25.
//

import Speech
import AVFoundation

public class SpeechTranscriberManager {
    
    static let shared = SpeechTranscriberManager()
    
    private var speechRecognizer: SFSpeechRecognizer?
    private var currentTask: SFSpeechRecognitionTask?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var audioEngine: AVAudioEngine?
    private var audioFile: AVAudioFile?
    
    private init() {
        setupRecognizer()
    }
    
    private func setupRecognizer() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        
        if speechRecognizer == nil {
            print("⚠️ Speech recognizer unavailable for en-US locale")
        }
    }
    
    func requestSpeechRecognizerPermission(completion: @escaping (Result<Void, NSError>) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    completion(.success(()))
                case .denied:
                    completion(.failure(NSError(domain: "SFSpeechRecongizerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Permission for speechRecognizer denied, please enable in settings"])))
                case .restricted:
                    completion(.failure(NSError(domain: "SFSpeechRecongizerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Permission for speechRecognizer restricted, please enable in settings"])))
                case .notDetermined:
                    completion(.failure(NSError(domain: "SFSpeechRecongizerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Permission for speechRecognizer not determined, please enable in settings"])))
                @unknown default:
                    completion(.failure(NSError(domain: "SFSpeechRecongizerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "unknown error occured, please try again later"])))
                }
            }
        }
    }
    
    // MARK: - Live Transcription
    func startLiveTranscription(
        recordingURL: URL,
        onUpdate: @escaping (String) -> Void,
        onError: @escaping (NSError) -> Void
    ) {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Speech recognizer unavailable"]))
            return
        }
        
        stopLiveTranscription()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: [])
            try audioSession.setPreferredSampleRate(44100.0)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            Thread.sleep(forTimeInterval: 0.1)
            print("🎤 Audio session sample rate: \(audioSession.sampleRate)")
        } catch {
            onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to configure audio session: \(error.localizedDescription)"]))
            return
        }
        
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else {
            onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create audio engine"]))
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create recognition request"]))
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        print("📊 Format - Sample Rate: \(recordingFormat.sampleRate), Channels: \(recordingFormat.channelCount)")
        
        guard recordingFormat.sampleRate > 0 && recordingFormat.channelCount > 0 else {
            onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid recording format - SR:\(recordingFormat.sampleRate) CH:\(recordingFormat.channelCount)"]))
            return
        }
        
        // CREATE M4A FILE WITH AAC COMPRESSION
        do {
            let aacSettings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderBitRateKey: 128000,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioFile = try AVAudioFile(
                forWriting: recordingURL,
                settings: aacSettings,
                commonFormat: .pcmFormatFloat32,
                interleaved: false
            )
            print("✅ Created M4A file for recording")
        } catch {
            onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create audio file: \(error.localizedDescription)"]))
            return
        }
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            recognitionRequest.append(buffer)
            try? self?.audioFile?.write(from: buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            print("✅ Audio engine started successfully")
        } catch {
            onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to start audio engine: \(error.localizedDescription)"]))
            return
        }
        
        currentTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Transcription error: \(error.localizedDescription)"]))
                    return
                }
                
                if let result = result {
                    onUpdate(result.bestTranscription.formattedString)
                }
            }
        }
    }
    func stopLiveTranscription() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        currentTask?.cancel()
        currentTask = nil
        audioEngine = nil
        audioFile = nil
        
        // Deactivate audio session
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
    

    
    // MARK: - File-based Transcription (existing)
    
    func transcribeAudio(url: URL, completion: @escaping (Result<String, NSError>) -> Void) {
        guard let recognizer = speechRecognizer else {
            completion(.failure(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "UnsupportedLocale"])))
            return
        }
        
        guard recognizer.isAvailable else {
            completion(.failure(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "File Transcription is currently unavailable"])))
            return
        }
        
        // Cancel any existing task
        currentTask?.cancel()
        
        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = false
        
        currentTask = recognizer.recognitionTask(with: request) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Audio Transcription Failed"])))
                    return
                }
                
                guard let result = result else {
                    completion(.failure(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "The Audio Transcription yielded no results"])))
                    return
                }
                
                if result.isFinal {
                    let transcribedText = result.bestTranscription.formattedString
                    completion(.success(transcribedText))
                }
            }
        }
    }
    
    func cancelCurrentTranscription() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    var isTranscribing: Bool {
        return currentTask != nil && currentTask?.state == .running
    }
}
