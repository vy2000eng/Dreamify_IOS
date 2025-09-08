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
        dreamRecordingsView          = DreamRecordsView()
        super.init                     (nibName: nil, bundle: nil)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
      //  if audioPlayer
       // print("recording view is not in the viewing context")
    }
    
    lazy var collectionView: UICollectionView! = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            // Main content item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(150)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(150)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16 // More generous spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
            
            // Header
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(60)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            header.pinToVisibleBounds = false // Less aggressive pinning
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DreamRecordingViewCell.self, forCellWithReuseIdentifier: "dreamCell")
        collectionView.register(DreamRecordingHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false // Cleaner look
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        self.dreamRecordingViewModel.presentErrIfAnalysisFailsDelagate = self
        setupUI                     ()
        setupConstraints            ()
        listFilesFromDocumentsFolder()

        super.viewDidLoad           ()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Dreams"
        
        // Modern navigation bar styling
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(collectionView)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint (equalTo: view.leadingAnchor                ),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor               ),
            collectionView.topAnchor.constraint     (equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint  (equalTo: view.bottomAnchor                 ),
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

