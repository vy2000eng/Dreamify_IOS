//
//  DreamRecordingViewControllerCollectionViewDataSource.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//

import UIKit

extension DreamRecordingsViewController:UICollectionViewDataSource{
    
    
    func dreamCell(indexPath:IndexPath) -> UICollectionViewCell{
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "dreamCell", for: indexPath) as? DreamRecordingViewCell
        else{
            fatalError("Unable to dequeue TopicViewCell. This is a developer error.")
        }
        let topic = dreamRecordingViewModel.dream(by: indexPath.row)
        cell.configure(with: topic)
        cell.delegate = self
        return cell

    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dreamCell(indexPath: indexPath)
    }
}
