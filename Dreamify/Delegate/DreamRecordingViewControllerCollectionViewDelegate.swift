//
//  DreamRecordingViewControllerCollectionViewDelegate.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//

import UIKit
import SwipeCellKit
import Foundation
import AVFAudio






extension DreamRecordingViewDataSourceManager:UICollectionViewDelegate, SwipeCollectionViewCellDelegate,AVAudioPlayerDelegate,AddNewRecordingToCollectionView, PresentErrIfAnalysisFails{

    // explicitly defined delegates
    func updateCollection(controllerMangedByDataSource :ControllerManagedByAudioPlayerClass) throws -> Void{
        print("delegate called")
        
        switch(controllerMangedByDataSource){
        case .DreamViewController:
            guard let  vc = self.controller as? DreamRecordingsViewController else{
                throw NSError(domain: "DreamCiewController Casting Exception", code: 1, userInfo: [NSLocalizedDescriptionKey: "could not cast controller to DreamViewContoller"])
                
            }
            do{
                vc.dreamRecordingViewModel.dreams = try vc.dreamRecordingViewModel.getAllDreamsForUser()
            }catch {
                print("An err occured in datasource manager")
                
            }
            
            let section = vc.dreamRecordingViewModel.dreamsCount
            if(controllerManagedByAudioPlayer == .DreamViewController && self.dreamRecordingViewModel.dreamsCount != vc.dreamRecordingView.collectionView.numberOfItems(inSection: 0) && vc.isViewLoaded){
                DispatchQueue.main.async{ [weak self] in
                    guard let self = self else{ return }
                    vc.dreamRecordingView.collectionView.insertItems(at: [IndexPath(row: section-1, section: 0)])
                }
                
            }
            break;
            
            
        case .CalendarViewController:
            guard let  vc = self.controller as? CalendarViewController else{
                throw NSError(domain: "CalendarViewController Casting Exception", code: 1, userInfo: [NSLocalizedDescriptionKey: "could not cast controller to CalendarViewContoller"])
                
            }
            do{
                vc.dreamRecordingViewModel.dreams = try vc.dreamRecordingViewModel.getAllDreamsForUser()
            }catch {
                print("An err occured in datasource manager")
            }
            
            do{
                guard let  currently_selected_date = retrieveCurrentlySelectedDateDelegate?.retrieveCurrentlySelectedDate() else{
                    return
                }
                
                if(controllerManagedByAudioPlayer == .CalendarViewController && vc.dreamRecordingViewModel.dreamsCount != vc.dreamRecordingView.collectionView.numberOfSections && vc.isViewLoaded){
                    DispatchQueue.main.async{ [weak self] in
                        guard let self = self else{ return }
                        vc.filterDreamsForDate( currently_selected_date)
                    }
                }
            }catch let err as NSError{
                throw NSError(domain: err.domain, code: 1, userInfo: [NSLocalizedDescriptionKey:err.localizedDescription])
            }
            
            
            break;
        }
    }
    
    
    func presentUiAlertErr(title:String, errMessage: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else{return}
            
            let alert = UIAlertController(title: title,
                                          message: errMessage,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.controller.present(alert, animated: true)
        
        }
        
     
    }
    
    
    

    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        switch(orientation){
        case .left:
            let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
                
                guard let self = self else { return }
                
                let dream = self.dreamRecordingViewModel.dream(by: indexPath.row)
                
                let filename = dream.url
                do {
                    print("item to be deleted at indexpath: \(indexPath)")
                    try deleteDream(indexPath: indexPath)
                    self.dreamRecordingViewModel.previouslyOpenedDreamId = nil
                    
                } catch {
                    print("Error deleting file '\(filename)': \(error.localizedDescription)")
                }

                
                
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
    
    
    func deleteDream(indexPath:IndexPath) throws ->Void{
        do{
            let dream = dreamRecordingViewModel.dream(by:indexPath.row)
            let filename = dream.url
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            let fileExists = FileManager.default.fileExists(atPath: url.path)

            if fileExists{
                switch controller {
                case is DreamRecordingsViewController:
                    try deleteSectionFromCollectionViewDelegateInCalendarViewController?.deleteRecording(id:dream.id)
                    break
                    
                case is CalendarViewController:
                    try deleteSectionFromCollectionViewInDreamViewControllerDelegate?.deleteRecording(id:dream.id)
                    break
                    
                default:
                    // TODO: add an actual error
                    print("an unexpected error occured")
                    break
                    
                }
                //1.)remove from array
                try dreamRecordingViewModel.removeDreamFromArray(id: dream.id)
                //2.) remove from core data
                try dreamRecordingViewModel.deleteDreamById(id: dream.id)
                //3.)remove from file system
                try FileManager.default.removeItem(atPath: url.path)
                
                DispatchQueue.main.async{ [weak self ] in
                    guard let self = self else {return}
                    //4.) remove from collection view
                    self.dreamRecordingsView.collectionView.deleteItems(at:    [indexPath])
                }
            }

            
        }catch{
            print("Error deleting file: \(error.localizedDescription)")
            
        }

    }

    

    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
                print("audio finished")
        
                do{
                    print("audio finished")
                    try  self.audioPlayerManager.stopAudio()
        
                    guard let curr_index  = dreamRecordingViewModel.getPlayPauseController().indexThatIsCurrentlyPlaying else{
                        throw NSError(domain: "AudioStoppingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Play Pause Controller is nil"])
        
        
                    }
                    guard let  currPlayingCell = self.dreamRecordingsView.collectionView.cellForItem(at: IndexPath(row: curr_index, section: 0) ) as? DreamRecordingViewCell else{
                        throw NSError(domain: "AudioStoppingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Play Pause Controller is accessing a variable that doesnt exist in the collection"])
        
        
                    }
                    let config    = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
                    currPlayingCell.playPauseButton.setImage(UIImage(systemName: "play", withConfiguration: config), for: .normal)
        
        
                }catch let err as NSError{
                    
                    let alert = UIAlertController(title: "An Unexpected Error Occured",
                                                  message: err.localizedDescription,//"You tapped the start recording button, but the action failed",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.controller.present(alert, animated: true)
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



extension DreamRecordingViewDataSourceManager {
    var dreamRecordingsView: DreamRecordsView {
        switch controller {
        case let vc as DreamRecordingsViewController:
            return vc.dreamRecordingView
        case let vc as CalendarViewController:
            return vc.dreamRecordingView
        default:
            fatalError("Unsupported controller type")
        }
    }
}
