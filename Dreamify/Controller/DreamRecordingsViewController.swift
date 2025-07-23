//
//  DreamRecordingsViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit

//MARK: note the delegated and datasources are in there designated folders
class DreamRecordingsViewController:UIViewController{

    var dreamRecordingsView    : DreamRecordsView
    var dreamRecordingViewModel: DreamRecordingViewModel
    
    init(dreamRecordingViewModel:DreamRecordingViewModel) {
        self.dreamRecordingViewModel = dreamRecordingViewModel
        dreamRecordingsView          = DreamRecordsView()
        super.init                     (nibName: nil, bundle: nil)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    lazy var collectionView: UICollectionView = {
//        
//        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
//            let itemSize  = NSCollectionLayoutSize          (widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.75))
//            let item      = NSCollectionLayoutItem          (layoutSize: itemSize)
//            let groupSize = NSCollectionLayoutSize          (widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(112))
//            let group     = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//            let section   = NSCollectionLayoutSection       (group: group)
//            section.interGroupSpacing = 10 // This adds vertical spacing between cells
//            return section
//        }
//        
//        let v                                       = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
//        
//        v.backgroundColor                           = .clear
//        v.contentInsetAdjustmentBehavior            = .automatic
//        v.delegate                                  = self
//        v.dataSource                                = self
//        v.register                                   (DreamRecordingViewCell.self, forCellWithReuseIdentifier: "dreamCell")
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
    lazy var collectionView:UICollectionView = {
       
        //var flowLayout = UICollectionViewFlowLayout()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.itemSize = CGSize(width: view.bounds.width, height: 100) // Example item size

       // flowLayout.itemSize = CGSize(width: 100, height: 100)


            
            
        
        let v = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        v.backgroundColor                           = .clear
        v.contentInsetAdjustmentBehavior            = .automatic
        
        v.delegate                                  = self
        v.dataSource                                = self
        v.register                                   (DreamRecordingViewCell.self, forCellWithReuseIdentifier: "dreamCell")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
        
        
        
        
    }()
    
    //override vi
    
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

