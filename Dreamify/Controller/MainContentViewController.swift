//
//  Untitled.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit
import AVFoundation



class MainViewController: UIViewController, AVAudioRecorderDelegate{
    
    var mainContentView         :  MainContentView
    var recordingSession        :  AVAudioSession!
    var audioRecorder           :  AVAudioRecorder!
    var dreamsRecordingViewModel:  DreamRecordingViewModel
    var scoped_file_name        :  String? // is set in startRecording()
    var scoped_url              :  String?
    
    init(dreamRecordingViewModel:DreamRecordingViewModel){
        scoped_file_name                = nil
        self.mainContentView            = MainContentView()
        self.dreamsRecordingViewModel   = dreamRecordingViewModel
        super.init                        (nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        setupUI()
        setupConstraints()
        recordingSession = AVAudioSession.sharedInstance()


        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.setupActions()
                    } else {
                        // failed to record!
                        let alert = UIAlertController(title: "action failed",
                                                    message: "You tapped the start recording button, but the action failed",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                        self.present(alert, animated: true)
                    }
                }
            }
        } catch {
            
            // failed to record!
        }
  
        //setupActions()


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

    //MARK: sets the scoped_file_name variable
    func startRecording() {
        //generate unique file name
        let dateFormatter               = DateFormatter()
        dateFormatter.dateFormat        = "d.M.yyyy.hh.mm.ss"
        let formattedDate               = dateFormatter.string(from: Date())
        let id                          = UUID()
        let unique_file_name            = formattedDate
        let local_url                   = getDocumentsDirectory().appendingPathComponent(unique_file_name)
        scoped_url                      = local_url.absoluteString
        scoped_file_name                = unique_file_name
        
        

        //configure audio recording
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {

            
            audioRecorder = try AVAudioRecorder(url: local_url, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            mainContentView.actionButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
        
    }
//    func startRecording(){
//        let text = "this is a test string that is going to be saved in the application directory";
//        let directory = URL.documentsDirectory
//        print("directory: \(directory.path())")
//        let file_url = directory.appendingPathComponent("document_file.txt")
//        
//        do{
//            let data =  text.data(using: .utf8)
//            try data?.write(to: file_url)
//            
//
//            
//        }catch{
//            print("text data err")
//            
//        }
//    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        do{
            
            if success{
                guard let unwrappedUrl = scoped_url else {
                    throw NSError(domain: "AudioRecordingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                }
                guard let unwrapped_file_name =  scoped_file_name else {
                    throw NSError(domain: "AudioRecordingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid FileName"])
                }
                
                try dreamsRecordingViewModel.addDream    (url: unwrappedUrl, title: unwrapped_file_name)
                scoped_url                             = nil
                scoped_file_name                       = nil
                try dreamsRecordingViewModel.getAllDreams()
                mainContentView.actionButton.setTitle("Tap to Record", for: .normal)

            }
            
        }catch let err as NSError{
            print("Error saving the staged changes \(err), \(err.userInfo)")

            //TODO: add alert here
            mainContentView.actionButton.setTitle("recording failed", for: .normal)
            
        }

    }
    

    
    @objc func recordTapped() {
        
        
            if audioRecorder == nil {
                startRecording()
            } else {
                
                finishRecording(success: true)
         
            }
        
       
     
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
   


}
