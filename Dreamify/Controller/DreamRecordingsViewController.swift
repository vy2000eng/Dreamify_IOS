//
//  DreamRecordingsViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit
import AVFAudio

//MARK: note the delegated and datasources are in there designated folders
class DreamRecordingsViewController:UIViewController, AVAudioPlayerDelegate{

    var dreamRecordingsView    : DreamRecordsView
    var dreamRecordingViewModel: DreamRecordingViewModel
    var audioPlayer : AVAudioPlayer?
    //let audioFile = /* An AVAudioFile instance that points to file that's open for reading. */
    //let audioEngine //= AVAudioEngine()
    //let playerNode //= AVAudioPlayerNode()
    
    init(dreamRecordingViewModel:DreamRecordingViewModel) {
        self.dreamRecordingViewModel = dreamRecordingViewModel
        dreamRecordingsView          = DreamRecordsView()
        super.init                     (nibName: nil, bundle: nil)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            let itemSize  = NSCollectionLayoutSize          (widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.75))
            let item      = NSCollectionLayoutItem          (layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize          (widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(175))
            let group     = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section   = NSCollectionLayoutSection       (group: group)
            section.interGroupSpacing = 10 // This adds vertical spacing between cells
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.15))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            header.pinToVisibleBounds = true  // This makes the header sticky
            section.boundarySupplementaryItems = [header]
            return section
        }
        
        let v                                       = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        v.backgroundColor                           = .clear
        v.contentInsetAdjustmentBehavior            = .automatic
        v.delegate                                  = self
        v.dataSource                                = self
        v.register                                   (DreamRecordingViewCell.self, forCellWithReuseIdentifier: "dreamCell")
        v.register                                    (DreamRecordingHeaderViewCell.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader , withReuseIdentifier: "headerCell")

        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        setupUI                     ()
        setupConstraints            ()
        listFilesFromDocumentsFolder()
        super.viewDidLoad           ()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title                = "Dreams"
        view.addSubview         (collectionView)

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
    func playAudio(dreamViewModel:DreamViewModel) throws -> Void{
        
        let isPlaying = dreamViewModel.getIsPlaying()
        
        let url = URL(string: dreamViewModel.url)
        
        do{
            if(isPlaying){
                
                audioPlayer = try AVAudioPlayer(contentsOf: url!) //AVAudioPlayer(contentsOf: url!)
                //audioPlayer?.setVolume(1.0, fadeDuration: .greatestFiniteMagnitude)

                //audioPlayer?.prepareToPlay()
                
                audioPlayer?.delegate = self
                audioPlayer?.volume = 1.0
                audioPlayer?.play()

                
            }else{
                stopAudio()
            }
        
            
        }catch let err as NSError {
            throw NSError(domain: "AudioPlayingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid FileName"])

            
       }
       
     
    }
    func stopAudio() {

   
        
            audioPlayer?.stop()
            audioPlayer = nil
    
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        stopAudio()
        //player.

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

