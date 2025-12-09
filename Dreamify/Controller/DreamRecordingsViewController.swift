//
//  DreamRecordingsViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit
import AVFAudio



//MARK: note the delegated and datasources are in there designated folders
class DreamRecordingsViewController:UIViewController, DeleteSectionFromCollectionView, UpdateDreamTitleAndTranscription{
    func updateTitleAndDescriptionInCollection() throws {
        print("update delegate called in dream recordingViewController")
        dreamRecordingViewModel.dreams = try dreamRecordingViewModel.getAllDreamsForUser()
        dreamRecordingView.collectionView.reloadData()
    }



    func deleteRecording(id:UUID) {
        print("dream vc delegate called")
        do{
            try self.dreamRecordingViewModel.removeDreamFromArray(id: id)

                self.dreamRecordingView.collectionView.reloadData()
            
        }catch let err{
            print("an error occured whilst removing dream from collection view in dreamRecordingViewController: \(err)")
        }

       
    }


    var dreamRecordingView             : DreamRecordsView
    var dreamRecordingViewModel        : DreamRecordingViewModel
    var audioPlayer                    : AVAudioPlayer?
    private var loadingOverlay         : LoadingOverlayView?
    var dreamRecordingDataSourceManager: DreamRecordingViewDataSourceManager!
    
    override func viewWillDisappear(_ animated: Bool) {
        print("exitting Dream View Recodings")
        guard let previosulyOpenDreamID = dreamRecordingViewModel.previouslyOpenedDreamId else {
     
            return
        }
        
        let dream = dreamRecordingViewModel.dream(by:previosulyOpenDreamID)
        dream.toggleIsOpen()

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            guard let self = self else {return}
            
            self.dreamRecordingView.collectionView.performBatchUpdates({
                self.dreamRecordingView.collectionView.reloadItems(at: [IndexPath(row: previosulyOpenDreamID, section: 0)])
            }, completion: nil)
        }
        dreamRecordingViewModel.previouslyOpenedDreamId = nil

        
    }
    

    
    init() {
        self.dreamRecordingViewModel = DreamRecordingViewModel(controllerManagedByDataSource: .DreamViewController)
        dreamRecordingView           = DreamRecordsView(frame: .zero)

        super.init                     (nibName: nil, bundle: nil)
        dreamRecordingDataSourceManager = DreamRecordingViewDataSourceManager(dreamRecordingView: dreamRecordingView, dreamRecordingViewModel: dreamRecordingViewModel, controller: self)



    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    override func viewDidLoad() {
        
        
        print("dream recording view loaded")
        super.viewDidLoad           ()
        title = "All Recordings"
        dreamRecordingView.collectionView.delegate = dreamRecordingDataSourceManager
        dreamRecordingView.collectionView.dataSource = dreamRecordingDataSourceManager
        self.dreamRecordingViewModel.presentErrIfAnalysisFailsDelagate = dreamRecordingDataSourceManager
        setupUI                     ()
        setupConstraints            ()
        listFilesFromDocumentsFolder()

    }


    


    private func setupUI() {
        view.backgroundColor = .systemBackground

        
        dreamRecordingView.translatesAutoresizingMaskIntoConstraints = false

        
        view.addSubview(dreamRecordingView)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dreamRecordingView.leadingAnchor.constraint (equalTo: view.leadingAnchor                ),
            dreamRecordingView.trailingAnchor.constraint(equalTo: view.trailingAnchor               ),
            dreamRecordingView.topAnchor.constraint     (equalTo: view.topAnchor),
            dreamRecordingView.bottomAnchor.constraint  (equalTo: view.bottomAnchor                 ),
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

