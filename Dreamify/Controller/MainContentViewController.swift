//
//  Untitled.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit
import AVFoundation
import BackgroundTasks


class MainViewController: UIViewController{
    
    var mainContentView          :  MainContentView
    var dreamsRecordingViewModel :  DreamRecordingViewModel
   // var audioRecordingManager    :  AudioRecorderManager
    weak var addNewRecordToDreamRecordingViewdelegate: AddNewRecordingToCollectionView?
    weak var addNewRecordToCalendarViewdelegate: AddNewRecordingToCollectionView?
    private var currentTranscription: String = ""
    private var isRecording: Bool = false
    private var currentRecordingFileName: String?
    
    
    let taskId = "dreamify.refreshAuthToken.backgroundTask"
    
    private var windowOrientation: UIInterfaceOrientation {
        return view.window?.windowScene?.interfaceOrientation ?? .portrait
    }
    init(){
        
        self.mainContentView            = MainContentView()
        self.dreamsRecordingViewModel   = DreamRecordingViewModel()
       // audioRecordingManager           = AudioRecorderManager()
        super.init                        (nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        Task {
//            if audioRecordingManager.getState() == .recording{
//                try? await audioRecordingManager.updateOrientation(interfaceOrientation: windowOrientation)
//                
//                
//            }
//        }
//    }
    
    
    
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        
        // Request microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] allowed in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if allowed {
                    self.setupActions()
                } else {
                    let alert = UIAlertController(
                        title: "Microphone Access Required",
                        message: "Please enable microphone access in Settings to record dreams",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
        
        // Request speech recognition permission
        SpeechTranscriberManager.shared.requestSpeechRecognizerPermission { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                print("Speech recognition permission granted")
                
            case .failure(let err):
                let alert = UIAlertController(
                    title: "Speech Recognition Required",
                    message: err.localizedDescription,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    
    
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Home"
        view.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: view.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    private func setupActions() {
        mainContentView.actionButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        
    }
}

extension MainViewController{
    private func startRecording() {
        APIClientManager.shared.authRequest(
            endpoint: "/account/GetTimeSinceLastRecording",
            method: "POST",
            body: ["AnalysisOrRecording":"Recording"],
            type: TimeSinceLastAnalysisOrRecordingResponse.self,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if response.TimeSinceLastRecordingOrAnalysis {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "d-M-yyyy.hh.mm.ss"
                            let fileName = dateFormatter.string(from: Date()) + ".m4a"
                            let recordingURL = getDocumentsDirectory().appendingPathComponent(fileName)
                            print(recordingURL)
                            
                            self.currentRecordingFileName = fileName
                            
                            SpeechTranscriberManager.shared.startLiveTranscription(
                                recordingURL: recordingURL,
                                onUpdate: { [weak self] text in
                                    self?.currentTranscription = text
                                    self?.mainContentView.updateTranscription(text: text)
                                },
                                onError: { [weak self] error in
                                    print("Error: \(error)")
                                    
                                    // Ignore normal errors that happen during recording
                                    let errorMessage = error.localizedDescription
                                    if errorMessage.contains("No speech detected") ||
                                       errorMessage.contains("Recognition request was canceled") {
                                        print("ℹ️ Normal transcription event - ignoring")
                                        return
                                    }
                                    
                                    // Only show alerts for actual errors
                                    self?.isRecording = false
                                    let alert = UIAlertController(
                                        title: "Recording Error",
                                        message: error.localizedDescription,
                                        preferredStyle: .alert
                                    )
                                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                                    self?.present(alert, animated: true)
                                }
                            )
                            
                            self.isRecording = true
                            self.mainContentView.startRecording()
                            
                        } else {
                            let alert = UIAlertController(
                                title: "Recording Limit Exceeded",
                                message: "You can only make 1 recording per 24 hours. Upgrade to Premium for unlimited recordings.",
                                preferredStyle: .alert
                            )
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                            alert.addAction(UIAlertAction(title: "Upgrade", style: .default, handler: { [weak self] _ in
                                let subscriptionViewController = SubscriptionViewController()
                                subscriptionViewController.modalPresentationStyle = .fullScreen
                                self?.navigationController?.present(subscriptionViewController, animated: true)
                            }))
                            self.present(alert, animated: true)
                        }
                        
                    case .failure(let error):
                        let errorAlert = UIAlertController(
                            title: "Error",
                            message: error.localizedDescription,
                            preferredStyle: .alert
                        )
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(errorAlert, animated: true)
                    }
                }
            }
        )
    }
    func finishRecording(success: Bool) {
        SpeechTranscriberManager.shared.stopLiveTranscription()
        
        
        
        
        
        if success, let fileName = currentRecordingFileName {
            do {
                let url = getDocumentsDirectory().appendingPathComponent(fileName)
                Task{
                    
                    
                    // DreamApiManager.shared.uploadDream(audioURL: file, fileName: <#T##String#>, tag: <#T##String?#>, transcribedText: <#T##String?#>, completion: <#T##(Result<DreamUploadResponse, APIError>) -> Void#>)
                    DreamApiManager.shared.uploadDream(
                        audioURL: url,
                        fileName: fileName,
                        tag: "",
                        transcribedText: currentTranscription
                        //analyzedText: "The Analysis has not been done yet"
                    ) { result in
                        switch result {
                        case .success(let response):
                            print("✅ Uploaded: \(response.fileUrl)")
                        case .failure(let error):
                            print("❌ Error: \(error)")
                        }
                    }
                }
                try dreamsRecordingViewModel.addDream(url: fileName, title: fileName, transcribedText: currentTranscription)
                try addNewRecordToDreamRecordingViewdelegate?.updateCollection(controllerMangedByDataSource: .DreamViewController)
                try addNewRecordToCalendarViewdelegate?.updateCollection(controllerMangedByDataSource: .CalendarViewController)
            } catch {
                print("Error saving: \(error)")
            }
        }
        
        mainContentView.stopRecording()
        isRecording = false
        currentRecordingFileName = nil
        currentTranscription = ""
    }
}

extension MainViewController{
    @objc private func recordTapped() {
        if !isRecording {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
}

