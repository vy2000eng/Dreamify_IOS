
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
    
    func startLiveTranscription(onUpdate: @escaping (String) -> Void, onError: @escaping (NSError) -> Void) {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Speech recognizer unavailable"]))
            return
        }
        
        // Cancel any existing task
        stopLiveTranscription()
        
        // Create audio engine
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else {
            onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create audio engine"]))
            return
        }
        
        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create recognition request"]))
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Audio engine failed to start"]))
            return
        }
        
        currentTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    onError(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Transcription error: \(error.localizedDescription)"]))
                    return
                }
                
                if let result = result {
                    let transcribedText = result.bestTranscription.formattedString
                    onUpdate(transcribedText)
                }
            }
        }
    }
    func stopLiveTranscription() {
        // Stop audio engine
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        
        // End recognition request
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        // Cancel task
        currentTask?.cancel()
        currentTask = nil
        audioEngine = nil
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
