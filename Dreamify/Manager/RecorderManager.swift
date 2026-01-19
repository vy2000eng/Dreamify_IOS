////
////  RecorderManager.swift
////  Dreamify
////
////  Created by Vladyslav Yatsuta on 7/25/25.
////
//
//import Foundation
//import AVFAudio
//import UIKit
//
//enum State  {
//    case stopped
//    case recording
//}
//
//public class AudioRecorderManager: NSObject, AVAudioRecorderDelegate {
//
//    private var recorder: AVAudioRecorder!
//    private var recordingSession:AVAudioSession!
//    private var state:State
//    private var uniqueFileName:String!
//  
//   // private var recodingFileName:String
//
//    // MARK: - Initialization
//
//    override init() {
//         state = State.stopped
//        super.init()
//    }
//  
//    
//  
//    // MARK: - Recorder Control
//
//    public func record() {
//        guard state != .recording else { return }
//        
//        recorder.record()
//        state = .recording
//    }
//    
//    public func stop() {
//        recorder.stop()
//        state = .stopped
//    }
//    
//  
//
//
//    // MARK: - Audio Session and Recorder Configuration
//    
//    func configureAudioSessionAndConfigureRecorderExternally() throws -> Void{
//        do {
//            try configureAudioSession()
//            try enableBuiltInMicrophone()
//        } catch let err as NSError {
//            throw NSError(domain: "AudioRecordingError", code: 1, userInfo: [NSLocalizedDescriptionKey: err.localizedDescription])
//
//        }
//        
//        
//    }
//
//    private func configureAudioSession() throws {
//        do {
//            // Get the instance of audio session.
//             recordingSession = AVAudioSession.sharedInstance()
//            
//            // Set the audio session category to record, allowing default to speaker and Bluetooth.
//            try recordingSession.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
//            
//            // Activate the audio session.
//            try recordingSession.setActive(true)
//            
//            
//        } catch {
//            throw NSError(domain: "AudioRecordingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "error in configuration"])
//
//            // If an error occurs during configuration, throw an appropriate error.
//           // throw AudioSessionError.configurationFailed
//        }
//    }
//
//   // private func enableBuiltInMicrophone() throws {...}
//    private func enableBuiltInMicrophone() throws {
//        // Get the instance of audio session.
//        let audioSession = AVAudioSession.sharedInstance()
//
//        // Get the audio inputs.
//        let availableInputs = audioSession.availableInputs
//        
//        // Find the available input that corresponds to the built-in microphone.
//        guard let builtInMicInput = availableInputs?.first(where: { $0.portType == .builtInMic }) else {
//            // If no built-in microphone is found, throw an error.
//            //throw AudioSessionError.missingBuiltInMicrophone
//            throw NSError(domain: "AudioRecordingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "build in microphone"])
//
//        }
//        
//        do {
//            // Set the built-in microphone as the preferred input.
//            try audioSession.setPreferredInput(builtInMicInput)
//        } catch {
//            throw NSError(domain: "AudioRecordingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "set preferred"])
//
//            // If an error occurs while setting the preferred input, throw an appropriate error.
//            //throw AudioSessionError.unableToSetBuiltInMicrophone
//        }
//    }
//    public func setupAudioRecorder() throws {
//
//        let dateFormatter               = DateFormatter()
//        dateFormatter.dateFormat        = "d-M-yyyy.hh.mm.ss"
//        let formattedDate               = dateFormatter.string(from: Date())
//        uniqueFileName            = formattedDate  + ".aac"
//        let local_url                   = getDocumentsDirectory().appendingPathComponent(uniqueFileName)
//
//        
//        
//        do {
//            let audioSettings: [String: Any] = [
//                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//                AVLinearPCMIsNonInterleaved: false,
//                AVSampleRateKey: 44_100.0,
//                AVNumberOfChannelsKey: 1,
//                AVLinearPCMBitDepthKey: 16,
//                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
//            ]
//            recorder = try AVAudioRecorder(url: local_url, settings: audioSettings)
//        } catch {
//            throw NSError(domain: "AudioRecordingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "unable to create audio recorder"])
//
//           // throw RecorderError.unableToCreateAudioRecorder
//        }
//        
//        //recorder.delegate = self
//        recorder.prepareToRecord()
//    }
//    public func updateOrientation(
//        withDataSourceOrientation orientation: AVAudioSession.Orientation = .front,
//        interfaceOrientation: UIInterfaceOrientation
//    ) async throws {
//        // Don't update the data source if the app is currently recording.
//        guard state != .recording else { return }
//
//        // Get the shared audio session.
//        let session = AVAudioSession.sharedInstance()
//
//        // Find the data source matching the specified orientation.
//        guard let preferredInput = session.preferredInput,
//              let dataSources = preferredInput.dataSources,
//              let newDataSource = dataSources.first(where: { $0.orientation == orientation }),
//              let supportedPolarPatterns = newDataSource.supportedPolarPatterns else {
//            return
//        }
//
//        do {
//            // Check for iOS 14.0 availability to handle stereo support.
//            if #available(iOS 14.0, *) {
//                //isStereoSupported = supportedPolarPatterns.contains(.stereo)
//
//                // Set the preferred polar pattern to stereo if supported.
//                //if isStereoSupported {
//                    try newDataSource.setPreferredPolarPattern(.stereo)
//                //}
//            }
//
//            // Set the preferred data source.
//            try preferredInput.setPreferredDataSource(newDataSource)
//
//            // Set the preferred input orientation based on the interface orientation.
//            //if #available(iOS 14.0, *) {
//            try session.setPreferredInputOrientation(session.inputOrientation)
//            //}
//        } catch {
//            throw NSError(domain: "AudioRecordingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "unable To Select Data Source"])
//
//            //throw RecorderError.unableToSelectDataSource(name: newDataSource.dataSourceName)
//        }
//    }
//
//    
//    
//    
//
//}
//
//
//
//extension AudioRecorderManager{
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//    func getUniqueFileName()->String?{
//        return self.uniqueFileName
//        
//    }
//    func getState() -> State{
//        return self.state
//    }
//    
//    func getRecordingSession() ->AVAudioSession{
//        return self.recordingSession
//    }
//    
//    public func getRecorder()->AVAudioRecorder!{
//        return self.recorder
//    }
//    public func deInitRecorder(){
//        self.recorder = nil
//    }
//}
//
