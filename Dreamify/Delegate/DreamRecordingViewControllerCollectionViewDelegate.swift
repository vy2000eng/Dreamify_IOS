//
//  DreamRecordingViewControllerCollectionViewDelegate.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//

import UIKit
import SwipeCellKit
import AVFAudio

extension DreamRecordingsViewController:UICollectionViewDelegate, SwipeCollectionViewCellDelegate,AVAudioPlayerDelegate,AddNewRecordingToCollectionView, PresentErrIfAnalysisFails{
    // explicitly defined delegates
    func updateCollection() {
        print("deldegate called")
        let section = dreamRecordingViewModel.dreamsCount
        DispatchQueue.main.async{ [weak self] in
            
            guard let self = self,
                  self.isViewLoaded,
                  self.collectionView != nil else{
                return
            }
            self.collectionView.insertSections(IndexSet(integer: section-1))
        }

    }
    func presentUiAlertErr(title:String, errMessage: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else{return}
            
            let alert = UIAlertController(title: title,
                                          message: errMessage,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.present(alert, animated: true)
        
        }
        
     
    }

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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
                print("audio finished")
        
                do{
                    print("audio finished")
                    try stopAudio()
        
                    guard let curr_index  = dreamRecordingViewModel.getPlayPauseController().indexThatIsCurrentlyPlaying else{
                        throw NSError(domain: "AudioStoppingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Play Pause Controller is nil"])
        
        
                    }
                    guard let  currPlayingCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: curr_index) ) as? DreamRecordingViewCell else{
                        throw NSError(domain: "AudioStoppingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Play Pause Controller is accessing a variable that doesnt exist in the collection"])
        
        
                    }
                    let config    = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
                    currPlayingCell.playPauseButton.setImage(UIImage(systemName: "play", withConfiguration: config), for: .normal)
        
        
                }catch let err as NSError{
                    let alert = UIAlertController(title: "An Unexpected Error Occured",
                                                  message: err.localizedDescription,//"You tapped the start recording button, but the action failed",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.present(alert, animated: true)
                    return
        
        
                }
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("🚫 Audio decode error: \(error?.localizedDescription ?? "Unknown")")
    }

    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        print("🔇 Audio interrupted")
    }
    
    
}



