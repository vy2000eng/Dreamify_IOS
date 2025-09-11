//
//  DreamRecordingsViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit
import AVFAudio



//MARK: note the delegated and datasources are in there designated folders
class DreamRecordingsViewController:UIViewController{

    var dreamRecordingsView    : DreamRecordsView
    var dreamRecordingViewModel: DreamRecordingViewModel
    var audioPlayer : AVAudioPlayer?
    
    init(dreamRecordingViewModel:DreamRecordingViewModel) {
        self.dreamRecordingViewModel = dreamRecordingViewModel
        dreamRecordingsView          = DreamRecordsView(frame: .zero)
        super.init                     (nibName: nil, bundle: nil)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: not sure why this is here
//    override func viewDidDisappear(_ animated: Bool) {
//      //  if audioPlayer
//       // print("recording view is not in the viewing context")
//    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad           ()

        self.dreamRecordingViewModel.presentErrIfAnalysisFailsDelagate = self
        dreamRecordingsView.translatesAutoresizingMaskIntoConstraints = false
        setupUI                     ()
        setupConstraints            ()
        listFilesFromDocumentsFolder()
        dreamRecordingsView.collectionView.delegate = self
        dreamRecordingsView.collectionView.dataSource = self

    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Dreams"
        
        // Modern navigation bar styling
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(dreamRecordingsView)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dreamRecordingsView.leadingAnchor.constraint (equalTo: view.leadingAnchor                ),
            dreamRecordingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor               ),
            dreamRecordingsView.topAnchor.constraint     (equalTo: view.safeAreaLayoutGuide.topAnchor),
            dreamRecordingsView.bottomAnchor.constraint  (equalTo: view.bottomAnchor                 ),
        ])
    }
    
    
    func listFilesFromDocumentsFolder(){
        do {
            // Get the document directory url
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            
            print("documentDirectory", documentDirectory.path)
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: documentDirectory,
                includingPropertiesForKeys: nil
            )

            for var url in directoryContents {
                url.hasHiddenExtension = true
            }
            for url in directoryContents {
                print(url.localizedName ?? url.lastPathComponent)
            }

            
        } catch {
            print(error)
        }
    }
    
}


// utilily functions for audio player
extension DreamRecordingsViewController{
    func  playAudio(fileName:String)  throws -> Void{
        
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do{
                
                audioPlayer = try  AVAudioPlayer(contentsOf: url) //AVAudioPlayer(contentsOf: url!)
         
            
                audioPlayer?.delegate = self
                audioPlayer?.volume = 1.0
                audioPlayer?.play()

        
            
        }catch let err as NSError {
            throw NSError(domain: "AudioPlayingError", code: 1, userInfo: [NSLocalizedDescriptionKey: err.localizedDescription])

            
       }
       
     
    }
    func stopAudio() throws ->Void {
            audioPlayer?.stop()
            audioPlayer = nil
    }


    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

    



extension URL {
    var typeIdentifier: String? { (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier }
    var isMP3: Bool { typeIdentifier == "public.mp3" }
    var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName }
    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}

