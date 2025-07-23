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
               // if self.viewmodel.sectionType(for: indexPath.section ) == .topics{
                    //self.deleteTopic(at: indexPath)
                //}else{
                //    self.deleteMap(at: indexPath)
              //  }
                //self.navigationItem.rightBarButtonItem = self.createOptionsBarButtonItem()
                
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dreamRecordingViewModel.dreamsCount
    }
    
    
    
    
    
}



