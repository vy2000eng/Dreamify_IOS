//
//  Untitled.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit
import AVFoundation



class MainViewController: UIViewController{
    
    var mainContentView          :  MainContentView
    var dreamsRecordingViewModel :  DreamRecordingViewModel
    var audioRecordingManager    : AudioRecorderManager
    private var windowOrientation: UIInterfaceOrientation {
          return view.window?.windowScene?.interfaceOrientation ?? .portrait
      }
    init(dreamRecordingViewModel : DreamRecordingViewModel){
        
        self.mainContentView            = MainContentView()
        self.dreamsRecordingViewModel   = dreamRecordingViewModel
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
              // Update the orientation of the audio recorder manager based on the window orientation.
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
                                                      message: "Please Enable Audio ini Settings to start Recording",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                        self.present(alert, animated: true)
                    }
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainContentView.actionButton.layer.cornerRadius =  mainContentView.actionButton.frame.width / 2
        
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Home"
        
        // Add subviews
        view.addSubview(mainContentView.titleLabel)
        view.addSubview(mainContentView.descriptionLabel)
        view.addSubview(mainContentView.actionButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title Label
            mainContentView.titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainContentView.titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            mainContentView.titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            mainContentView.titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            // Description Label
            mainContentView.descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainContentView.descriptionLabel.topAnchor.constraint(equalTo: mainContentView.titleLabel.bottomAnchor, constant: 20),
            mainContentView.descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainContentView.descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Action Button
            mainContentView.actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainContentView.actionButton.topAnchor.constraint(equalTo: mainContentView.descriptionLabel.bottomAnchor, constant: 40),
            mainContentView.actionButton.widthAnchor.constraint(equalToConstant: 200),
            mainContentView.actionButton.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupActions() {
        mainContentView.actionButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        
    }
}

extension MainViewController{
    private func startRecording(){
        do{
            try audioRecordingManager.setupAudioRecorder()
            audioRecordingManager.getRecorder ().delegate = self
            
            audioRecordingManager.record()
            mainContentView.actionButton.setTitle("Tap to Stop", for: .normal)
            
        }catch let err as NSError{
            let alert = UIAlertController(title: "An Unexpected Error Occured",
                                          message: err.localizedDescription,//"You tapped the start recording button, but the action failed",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.present(alert, animated: true)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecordingManager.stop()
        do{
            
            if success{
                guard let unwrappedUrl = audioRecordingManager.getRecorder()?.url.absoluteString else {
                    throw NSError(domain: "AudioRecordingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                }
                guard let unwrapped_file_title =  audioRecordingManager.getUniqueFileName() else {
                    throw NSError(domain: "AudioRecordingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid FileName"])
                }
                
                try dreamsRecordingViewModel.addDream(url: unwrappedUrl, title: unwrapped_file_title)
                
                try dreamsRecordingViewModel.getAllDreams()
                mainContentView.actionButton.setTitle("Tap to Record", for: .normal)
                
            }
        }catch let err as NSError{
            print("Error saving the staged changes \(err), \(err.userInfo)")
            
            //TODO: add alert here
            mainContentView.actionButton.setTitle("recording failed", for: .normal)
            
        }
        audioRecordingManager.deInitRecorder()
        
        
        
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

