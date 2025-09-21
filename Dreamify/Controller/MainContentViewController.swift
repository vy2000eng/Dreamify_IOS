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

    
    let taskId = "dreamify.refreshAuthToken.backgroundTask"

    
   // var SpeechTranscriberManager
    
    private var windowOrientation: UIInterfaceOrientation {
          return view.window?.windowScene?.interfaceOrientation ?? .portrait
      }
    init(){
        
        self.mainContentView            = MainContentView()
        self.dreamsRecordingViewModel   = DreamRecordingViewModel()
        audioRecordingManager           = AudioRecorderManager()
        //self.speechTranscriberManager = SpeeachTranscriberManager()
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
    private func startRecording(){
        do{
            try audioRecordingManager.setupAudioRecorder()
            audioRecordingManager.getRecorder ().delegate = self
            
            audioRecordingManager.record()
            mainContentView.startRecording()
            

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

                guard let unwrapped_file_title =  audioRecordingManager.getUniqueFileName() else {
                    throw NSError(domain: "AudioRecordingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid FileName"])
                }
                
                
                

                        SpeechTranscriberManager.shared.transcribeAudio(url: self.audioRecordingManager.getDocumentsDirectory().appending(component: unwrapped_file_title)) { [weak self] transcriptionResult in
                            guard let self = self else{
                                return
                            }
                            switch transcriptionResult {
                            case .success(let text):
                                do{
                                    print(text)
                                    try dreamsRecordingViewModel.addDream(url: unwrapped_file_title, title: unwrapped_file_title,transcribedText: text)
                                    mainContentView.stopRecording()


                                    try addNewRecordToDreamRecordingViewdelegate?.updateCollection(controllerMangedByDataSource: .DreamViewController)
                                    try addNewRecordToCalendarViewdelegate?.updateCollection(controllerMangedByDataSource: .CalendarViewController)
                                    
                                }catch let err as NSError{
                                   // try dreamsRecordingViewModel.addDream(url: unwrapped_file_title, title: unwrapped_file_title,transcribedText: text)
                                    SpeechTranscriberManager.shared.cancelCurrentTranscription()
                                    let alert = UIAlertController(title: "An Unexpected Error Occured",
                                                                  message: err.localizedDescription,//"You tapped the start recording button, but the action failed",
                                                                  preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                                    self.present(alert, animated: true)
                                   // mainContentView.actionButton.setTitle("Tap to Record", for: .normal)
                                    mainContentView.stopRecording()

                                    
                                }

                                print("Transcribed: \(text)")
                            case .failure(let err):
                                SpeechTranscriberManager.shared.cancelCurrentTranscription()

                                mainContentView.stopRecording()


                                let alert = UIAlertController(title: "An Unexpected Error Occured",
                                                              message: err.localizedDescription,//"You tapped the start recording button, but the action failed",
                                                              preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                                self.present(alert, animated: true)

                                do{
                                    try dreamsRecordingViewModel.addDream(url: unwrapped_file_title, title: unwrapped_file_title,transcribedText: nil)
                                    try addNewRecordToDreamRecordingViewdelegate?.updateCollection(controllerMangedByDataSource: .DreamViewController)
                                    try addNewRecordToCalendarViewdelegate?.updateCollection(controllerMangedByDataSource: .CalendarViewController)
                                    
                                    
                                    
                                }catch let err as NSError{

                                    let alert = UIAlertController(title: "An Error occured while saving your recording",
                                                                  message: err.localizedDescription,//"You tapped the start recording button, but the action failed",
                                                                  preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                                    self.present(alert, animated: true)
                                    //mainContentView.actionButton.setTitle("Tap to Record", for: .normal)
                                    
                                }
                            }
                        }

                

           
                
                
                
                
                
                
                
            }
        }catch let err as NSError{
            let alert = UIAlertController(title: "An Unexpected Error Occured",
                                          message: err.localizedDescription,//"You tapped the start recording button, but the action failed",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.present(alert, animated: true)
            mainContentView.actionButton.setTitle("Tap to Record", for: .normal)


            
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

