//
//  DreamRecordings.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//


import Foundation
import UIKit



class DreamRecordsView:UIView{
//    let titleLabel: UILabel = {
//          let label = UILabel()
//          label.text = "This is where all you're dream will be "
//          label.font = UIFont.boldSystemFont(ofSize: 24)
//          label.textAlignment = .center
//          label.textColor = .systemBlue
//          label.translatesAutoresizingMaskIntoConstraints = false
//          return label
//      }()
//    
//    
//    let dreamsLabel:UILabel = {
//        let label = UILabel()
//        label.text = "/path/to/directory/of/recording"
//
//        label.font = UIFont.boldSystemFont(ofSize: 24)
//        label.textAlignment = .center
//        label.textColor = .systemBlue
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label;
//        
//        
//    }()
    //var dreamRecordingsView    : DreamRecordsView
    //var dreamRecordingViewModel: DreamRecordingViewModel
    
    
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
        
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .automatic
//        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.register(DreamRecordingViewCell.self, forCellWithReuseIdentifier: "dreamCell")
        collectionView.register(DreamRecordingHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false // Cleaner look
        
        
        return collectionView
    }()

    
    override init(frame: CGRect) {
        
        
        super.init(frame:   frame)
        setupUi()
        setupConstraints()
        
    }
    
    private func setupUi(){
        addSubview(collectionView)
        
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint (equalTo:  leadingAnchor                ),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor               ),
            collectionView.topAnchor.constraint     (equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint  (equalTo: bottomAnchor                 ),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
