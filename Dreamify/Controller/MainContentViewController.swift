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
    var audioRecordingManager    :  AudioRecorderManager
    weak var addNewRecordToDreamRecordingViewdelegate: AddNewRecordingToCollectionView?
    weak var addNewRecordToCalendarViewdelegate: AddNewRecordingToCollectionView?
    private var currentTranscription: String = ""

    
    
    let taskId = "dreamify.refreshAuthToken.backgroundTask"
    
    private var windowOrientation: UIInterfaceOrientation {
        return view.window?.windowScene?.interfaceOrientation ?? .portrait
    }
    init(){
        
        self.mainContentView            = MainContentView()
        self.dreamsRecordingViewModel   = DreamRecordingViewModel()
        audioRecordingManager           = AudioRecorderManager()
        super.init                        (nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        Task {
            if audioRecordingManager.getState() == .recording{
                try? await audioRecordingManager.updateOrientation(interfaceOrientation: windowOrientation)
                
                
            }
        }
    }
    
    
    
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        
        do {
            try audioRecordingManager.configureAudioSessionAndConfigureRecorderExternally()
            
            let recordingSession = audioRecordingManager.getRecordingSession()
            
            recordingSession.requestRecordPermission() { [weak self] allowed in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    
                    if allowed {
                        self.setupActions()
                    } else {
                        // failed to record!
                        let alert = UIAlertController(title: "action failed",
                                                      message: "Please Enable Microphone Settings to start Recording",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                        self.present(alert, animated: true)
                    }
                }
            }
            SpeechTranscriberManager.shared.requestSpeechRecognizerPermission(){[weak self] result in
                guard let self = self else{
                    return
                }
                switch result{
                case.success:
                    print("success")
                    
                case .failure(let err):
                    let alert = UIAlertController(title: "action failed",
                                                  message: err.localizedDescription,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.present(alert, animated: true)
                }
                
                
                
            }
        } catch let err as NSError{
            let alert = UIAlertController(title: "An Unexpected Error Occured",
                                          message: err.localizedDescription,//"You tapped the start recording button, but the action failed",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.present(alert, animated: true)
            
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
                
                // Add 'execute:' parameter label
                DispatchQueue.main.async(execute: {
                    switch result {
                    case .success(let response):
                        print(response)
                        if response.TimeSinceLastRecordingOrAnalysis {
                            do {
                                try self.audioRecordingManager.setupAudioRecorder()
                                self.audioRecordingManager.getRecorder().delegate = self
                                self.audioRecordingManager.record()
                                
                                SpeechTranscriberManager.shared.startLiveTranscription(
                                    onUpdate: { [weak self] transcribedText in
                                        self?.currentTranscription = transcribedText
                                        self?.mainContentView.updateTranscription(text: transcribedText)
                                    },
                                    onError: { [weak self] error in
                                        print("Transcription error: \(error.localizedDescription)")
                                    }
                                )
                                
                                self.mainContentView.startRecording()
                                
                            } catch let err as NSError {
                                let alert = UIAlertController(
                                    title: "An Unexpected Error Occurred",
                                    message: err.localizedDescription,
                                    preferredStyle: .alert
                                )
                                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                                self.present(alert, animated: true)
                            }
                            
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
                })
            }
        )
    }
    func finishRecording(success: Bool) {
        SpeechTranscriberManager.shared.stopLiveTranscription()
        
        audioRecordingManager.stop()
        
        do {
            if success {
                guard let unwrapped_file_title = audioRecordingManager.getUniqueFileName() else {
                    throw NSError(domain: "AudioRecordingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid FileName"])
                }
                
                // Use the currentTranscription that was updated in real-time
                let transcribedText = currentTranscription
                
                do {
                    print(transcribedText)
                    try dreamsRecordingViewModel.addDream(url: unwrapped_file_title, title: unwrapped_file_title, transcribedText: transcribedText)
                    mainContentView.stopRecording()
                    
                    try addNewRecordToDreamRecordingViewdelegate?.updateCollection(controllerMangedByDataSource: .DreamViewController)
                    try addNewRecordToCalendarViewdelegate?.updateCollection(controllerMangedByDataSource: .CalendarViewController)
                    
                } catch let err as NSError {
                    let alert = UIAlertController(title: "An Unexpected Error Occured",
                                                  message: err.localizedDescription,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.present(alert, animated: true)
                    mainContentView.stopRecording()
                }
            }
        } catch let err as NSError {
            let alert = UIAlertController(title: "An Unexpected Error Occured",
                                          message: err.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.present(alert, animated: true)
            mainContentView.actionButton.setTitle("Tap to Record", for: .normal)
        }
        
        audioRecordingManager.deInitRecorder()
        currentTranscription = ""
    }
}

extension MainViewController{
    @objc private func recordTapped() {
        
        
        if audioRecordingManager.getState()  == .stopped {
            
            
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
}

