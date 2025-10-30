//
//  SpeeachRecognizerManager.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/27/25.
//


import Speech



public class SpeechTranscriberManager{
//    
//
    static let shared = SpeechTranscriberManager()
     
     private var speechRecognizer: SFSpeechRecognizer?
     private var currentTask: SFSpeechRecognitionTask?
     
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
    func transcribeAudio(url: URL, completion: @escaping (Result<String, NSError>) -> Void) {
            guard let recognizer = speechRecognizer else {
                completion(.failure( NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "UnsupportedLocale"])))
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
                        completion(.failure(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Audio Transcription Failed"])))//.failure(.transcriptionFailed(error.localizedDescription)))
                        return
                    }
                    
                    guard let result = result else {
                        completion(.failure(NSError(domain: "AudioTranscriptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "The Audio Transcription yielded no results"])))//.noResult))
                        return
                    }
                    
                    // Check if this is the final result
                    if result.isFinal {
                        let transcribedText = result.bestTranscription.formattedString
                        completion(.success(transcribedText))
                    } else if !request.shouldReportPartialResults {
                        // If we're not reporting partial results, wait for final
                        return
                    }
                }
            }
        }
    
    func cancelCurrentTranscription() {
         currentTask?.cancel()
         currentTask = nil
     }
     
     // Check if transcription is currently running
     var isTranscribing: Bool {
         return currentTask != nil && currentTask?.state == .running
     }

}
