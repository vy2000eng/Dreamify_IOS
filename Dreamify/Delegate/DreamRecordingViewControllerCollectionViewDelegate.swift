//
//  DreamRecordingViewControllerCollectionViewDelegate.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//

import UIKit
import SwipeCellKit

extension DreamRecordingsViewController:UICollectionViewDelegate, SwipeCollectionViewCellDelegate{
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        switch(orientation){
        case .left:
            
            let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                
            }
            deleteAction.image = UIImage(systemName: "trash")
            return [deleteAction]
            
        case .right:
            
            let favoriteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                print("fave tapped")
            }
            
            favoriteAction.image = UIImage(systemName: "star")
            favoriteAction.backgroundColor = .orange
            return [favoriteAction]
        }

    }
}



