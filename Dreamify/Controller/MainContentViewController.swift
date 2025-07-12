//
//  Untitled.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit
import AVFoundation



class MainViewController: UIViewController, AVAudioRecorderDelegate{
    
    var mainContentView:MainContentView
    //var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    init(){
        self.mainContentView = MainContentView()
        
        super.init(nibName: nil, bundle: nil)

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
    
    
//    func loadRecordingUI() {
//        recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
//        recordButton.setTitle("Tap to Record", for: .normal)
//        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
//        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
//        view.addSubview(recordButton)
//    }
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            mainContentView.actionButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            mainContentView.actionButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            mainContentView.actionButton.setTitle("recording failed", for: .normal)
            // recording failed :(
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
