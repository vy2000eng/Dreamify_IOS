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
        let dream = dreamRecordingViewModel.dream(by: indexPath.row)
        //cell.configure(with: dream,)
        cell.configure(with: dream, parentWidth: collectionView.frame.width)
        cell.playPauseButton.tag    = indexPath.row
        cell.playPauseButton.addTarget(self, action: #selector(handlePlayPause( _:)) , for: .touchUpInside)
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        if(dream.getIsPlaying){
            cell.playPauseButton.setImage(UIImage(systemName: "pause",withConfiguration: config), for: .normal)
        }else{
            cell.playPauseButton.setImage(UIImage(systemName: "play",withConfiguration: config), for: .normal)
        }
        cell.delegate = self
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dreamCell(indexPath: indexPath)
    }
    //func collectio
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item \(indexPath.row)")
        
        if let curr_cell = self.collectionView.cellForItem(at: indexPath) as? DreamRecordingViewCell{
            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlUp, animations: {

                curr_cell.frame.size.height = 200
                var constrnt = curr_cell.mainContentView.bottomAnchor.constraint(equalTo: curr_cell.bottomAnchor, constant: 2)
                constrnt.isActive = true
                // curr_cell.addExpandedViewToMainView()

            }, completion: {[weak self] _ in
                
                guard let self = self else{
                    return
                }
                
                //collectionView.performBatchUpdates(<#T##updates: (() -> Void)?##(() -> Void)?##() -> Void#>)
                
                
                
               // Inde
                //var previousIndexPath =
               // self.collectionView.reloa
                //self.collectionView.reloadData()
            })
        }
//        curr_cell?.testLabel.text = "this is a test"
//        curr_cell?.addExpandedViewToMainView()
        
        
        
        //var cell = dreamCell(indexPath: indexPath)
        
        //        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "dreamCell", for: indexPath) as? DreamRecordingViewCell
//        else{
//            fatalError("Unable to dequeue TopicViewCell. This is a developer error.")
//        }
//        print("clicked on \(indexPath.row)")
//        let dream = dreamRecordingViewModel.dream(by: indexPath.row)
//        cell.configure(with: dream)
//        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
//        cell.playPauseButton.setImage(UIImage(systemName: "pause",withConfiguration: config), for: .normal)
//        cell.delegate = self
       // cell.addExpandedViewToMainView()
        
        
    }
    
    
    
    @objc
    func handlePlayPause(_ sender:UIButton) throws -> Void{
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let curr_cell =  self.collectionView.cellForItem(at: indexPath) as? DreamRecordingViewCell
        
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        let dream = dreamRecordingViewModel.dream(by: indexPath.row)
       
        dream.getIsPlaying == false
        ? curr_cell?.playPauseButton.setImage(UIImage(systemName: "pause",withConfiguration: config), for: .normal)
        : curr_cell?.playPauseButton.setImage(UIImage(systemName: "play",withConfiguration: config), for: .normal)
    
        DispatchQueue.main.async{
            [weak self ] in
            
            guard let self = self else{
                return
            }
         
            dream.togglePlayPauseButton()
            self.collectionView.reloadItems(at: [indexPath])
        }


     
   
    }
}
