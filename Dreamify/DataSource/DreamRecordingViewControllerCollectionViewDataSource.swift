//
//  DreamRecordingViewControllerCollectionViewDataSource.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//

import UIKit

extension DreamRecordingsViewController:UICollectionViewDataSource{
    
    func dreamCell(indexPath:IndexPath) -> UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dreamCell", for: indexPath) as? DreamRecordingViewCell
        else{
            fatalError("Unable to dequeue TopicViewCell. This is a developer error.")
        }
        let dream = dreamRecordingViewModel.dream(by: indexPath.section)
        cell.configure(with: dream)
        cell.playPauseButton.tag    = indexPath.section
        cell.playPauseButton.addTarget(self, action: #selector(handlePlayPause( _:)) , for: .touchUpInside)
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        if(dream.getIsPlaying){
            cell.playPauseButton.setImage(UIImage(systemName: "pause",withConfiguration: config), for: .normal)
        }else{
            cell.playPauseButton.setImage(UIImage(systemName: "play" ,withConfiguration: config), for: .normal)
        }
        cell.delegate = self
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dreamCell(indexPath: IndexPath(row: 0, section: indexPath.section))
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if let curr_cell = self.collectionView.cellForItem(at: indexPath) as? DreamRecordingHeaderViewCell{
//            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlUp, animations: { [weak self] in
//                guard let self = self else{
//                    return
//                }
//                var  currViewModel = self.dreamRecordingViewModel.dream(by: indexPath.section)
//                currViewModel.toggleIsOpen()
//                
//
//            }, completion: {[weak self] _ in
//                
//                guard let self = self else{
//                    return
//                }
//                self.collectionView.reloadItems(at: [ IndexPath(row: 0, section: indexPath.section)])
//            })
//        }

        
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind:     kind, withReuseIdentifier: "headerCell", for: indexPath) as! DreamRecordingHeaderViewCell
        cell.configureDreamRecordingViewHeader(viewmodel: dreamRecordingViewModel, row: indexPath.section)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        cell.headerView.isUserInteractionEnabled = true
        cell.headerView.addGestureRecognizer(tapGesture)
        cell.headerView.tag = indexPath.section
        return cell
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dreamRecordingViewModel.dreamsCount
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let dream = dreamRecordingViewModel.dream(by: section)
        if(dream.retrieveIsOpen()){
            return 1
        }
        return 0;
        
    }
    
    

}

extension DreamRecordingsViewController{
    @objc
    func handlePlayPause(_ sender:UIButton) throws -> Void{
        
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let curr_cell = self.collectionView.cellForItem(at: indexPath) as? DreamRecordingViewCell
        let config    = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        let dream     = dreamRecordingViewModel.dream(by: indexPath.section)
       
        dream.getIsPlaying == false
        ? curr_cell?.playPauseButton.setImage(UIImage(systemName: "pause",withConfiguration: config), for: .normal)
        : curr_cell?.playPauseButton.setImage(UIImage(systemName: "play" ,withConfiguration: config), for: .normal)
    
        DispatchQueue.main.async {
            [weak self ] in
            
            guard let self = self else{
                return
            }
         
            dream.togglePlayPauseButton()
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    @objc
    func handleTapGesture(gesture: UITapGestureRecognizer){
        
        if gesture.state == .ended{
            
            print("tapped")
            guard let id = gesture.view?.tag else {
                fatalError("Developer Error: viewID is nil or out of range (0-4)")
            }
            let dream = dreamRecordingViewModel.dream(by: id)
            dream.toggleIsOpen()
            
            if(dream.retrieveIsOpen()){
                self.collectionView.insertItems(at:[ IndexPath(row: 0, section: id)])
            }else{
                self.collectionView.deleteItems(at:[ IndexPath(row: 0, section: id)])

            }
            
        }
        
    }
    
}
