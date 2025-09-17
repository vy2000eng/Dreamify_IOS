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
    private var loadingOverlay: LoadingOverlayView?
    var dreamRecordingDataSourceManager: DreamRecordingViewDataSourceManager!

    
    init() {
        self.dreamRecordingViewModel = DreamRecordingViewModel()
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
        
        
        print("dream recording view loaded")
        super.viewDidLoad           ()
        title = "All Recordings"
        dreamRecordingDataSourceManager = DreamRecordingViewDataSourceManager(dreamRecordingView: dreamRecordingsView, dreamRecordingViewModel: dreamRecordingViewModel, controller: self)



        self.dreamRecordingViewModel.presentErrIfAnalysisFailsDelagate = dreamRecordingDataSourceManager
        setupUI                     ()
        setupConstraints            ()
        listFilesFromDocumentsFolder()
        dreamRecordingsView.collectionView.delegate = dreamRecordingDataSourceManager
        dreamRecordingsView.collectionView.dataSource = dreamRecordingDataSourceManager


 

        

    }


    


    private func setupUI() {
        view.backgroundColor = .systemBackground

        
        dreamRecordingsView.translatesAutoresizingMaskIntoConstraints = false

        
        view.addSubview(dreamRecordingsView)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dreamRecordingsView.leadingAnchor.constraint (equalTo: view.leadingAnchor                ),
            dreamRecordingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor               ),
            dreamRecordingsView.topAnchor.constraint     (equalTo: view.topAnchor),
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
//    func  playAudio(fileName:String)  throws -> Void{
//        
//        let url = getDocumentsDirectory().appendingPathComponent(fileName)
//        
//        do{
//                
//                audioPlayer = try  AVAudioPlayer(contentsOf: url) //AVAudioPlayer(contentsOf: url!)
//         
//            
//                audioPlayer?.delegate = self
//                audioPlayer?.volume = 1.0
//                audioPlayer?.play()
//
//        
//            
//        }catch let err as NSError {
//            throw NSError(domain: "AudioPlayingError", code: 1, userInfo: [NSLocalizedDescriptionKey: err.localizedDescription])
//
//            
//       }
//       
//     
//    }
//    func stopAudio() throws ->Void {
//            audioPlayer?.stop()
//            audioPlayer = nil
//    }


    
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
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
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
}


extension DreamRecordingsViewController{
    private func showLoading() {
           hideLoading() // Remove any existing overlay
           
           let loading = LoadingOverlayView(
               title: "Analyzing dream...",
               subtitle: "Please wait while we analyze your dream"
           )
           loading.show(in: view)
           loadingOverlay = loading
       }
       
       private func hideLoading() {
           loadingOverlay?.hide()
           loadingOverlay = nil
       }
}

