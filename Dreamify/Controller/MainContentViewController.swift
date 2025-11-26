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
            
            recordingSession.requestRecordPermission() { [unowned self] allowed in
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
        do {
            try audioRecordingManager.setupAudioRecorder()
            audioRecordingManager.getRecorder().delegate = self
            
            audioRecordingManager.record()
            
            // Start live transcription
            SpeechTranscriberManager.shared.startLiveTranscription(
                onUpdate: { [weak self] transcribedText in
                    // Update your UI with the transcribed text in real-time
                    self?.currentTranscription = transcribedText
                    self?.mainContentView.updateTranscription(text: transcribedText)
                },
                onError: { [weak self] error in
                    print("Transcription error: \(error.localizedDescription)")
                    // Optionally show error to user
                }
            )
            
            mainContentView.startRecording()
            
        } catch let err as NSError {
            let alert = UIAlertController(title: "An Unexpected Error Occured",
                                          message: err.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.present(alert, animated: true)
        }
    }
    
    

    func finishRecording(success: Bool) {
        // Stop live transcription
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

