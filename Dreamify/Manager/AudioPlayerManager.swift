//
//  AudioPlayerManager.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/15/25.
//

import  UIKit
import Foundation
import AVFAudio


class AudioPlayerManager: NSObject{
    private var audioPlayer: AVAudioPlayer!
    private var viewController:UIViewController?
    private var viewModel:DreamRecordingViewModel
    private var controllerManagedByAudioPlayer:ControllerManagedByAudioPlayerClass

    init(viewcontroller:UIViewController,viewmodel:DreamRecordingViewModel, controllerManagedByAudioPlayer:ControllerManagedByAudioPlayerClass) {
        self.viewModel = viewmodel 
       
        self.controllerManagedByAudioPlayer = controllerManagedByAudioPlayer
        self.viewController = viewcontroller
        
        switch(self.controllerManagedByAudioPlayer){
        case .DreamViewController:
            self.viewController = viewController as! DreamRecordingsViewController
        case .CalendarViewController:
            self.viewController = viewController as! CalendarViewController
        }
        super.init()


      }
    
    
    func  playAudio(fileName:String)  throws -> Void{
        
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do{
                
                audioPlayer = try  AVAudioPlayer(contentsOf: url)
         
            
                audioPlayer?.delegate = self
                audioPlayer?.volume = 1.0
                audioPlayer?.play()

        
            
        }catch let err as NSError {
            throw NSError(domain: "AudioPlayingError", code: 1, userInfo: [NSLocalizedDescriptionKey: err.localizedDescription])

            
       }
       
     
    }
    func stopAudio() throws ->Void {
            audioPlayer?.stop()
            audioPlayer = nil
    }
}

extension AudioPlayerManager:AVAudioPlayerDelegate{
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audio finished")
        

        
        
        do{
            print("audio finished")
            try stopAudio()
            
            guard let curr_index  = viewModel.getPlayPauseController().indexThatIsCurrentlyPlaying else{
                throw NSError(domain: "AudioStoppingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Play Pause Controller is nil"])
                
                
            }
            
            if let dreamVC = viewController as? DreamRecordingsViewController {
                guard let  currPlayingCell = dreamVC.dreamRecordingView.collectionView.cellForItem(at: IndexPath(row: curr_index, section:0) ) as? DreamRecordingViewCell else{
                    throw NSError(domain: "AudioStoppingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Play Pause Controller is accessing a variable that doesnt exist in the collection"])
                    
                    
                }
                let config    = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
                currPlayingCell.playPauseButton.setImage(UIImage(systemName: "play", withConfiguration: config), for: .normal)
                
            }
            if let calendarViewController = viewController as? CalendarViewController {
                guard let  currPlayingCell = calendarViewController.dreamRecordingView.collectionView.cellForItem(at: IndexPath(row: curr_index, section:0) ) as? DreamRecordingViewCell else{
                    throw NSError(domain: "AudioStoppingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Play Pause Controller is accessing a variable that doesnt exist in the collection"])
                    
                    
                }
                let config    = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
                currPlayingCell.playPauseButton.setImage(UIImage(systemName: "play", withConfiguration: config), for: .normal)
                
            }
            
            
            
            
        }catch let err as NSError{
            
            if let dreamVC = viewController as? DreamRecordingsViewController {
                let alert = UIAlertController(title: "An Unexpected Error Occured",
                                              message: err.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                dreamVC.present(alert, animated: true)
                return
                
            }
            if let calendarVC = viewController as? CalendarViewController {
                let alert = UIAlertController(title: "An Unexpected Error Occured",
                                              message: err.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                calendarVC.present(alert, animated: true)
                return
                
            }
            
            
            
            
            
            
            
        }
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("🚫 Audio decode error: \(error?.localizedDescription ?? "Unknown")")
    }

    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        print("🔇 Audio interrupted")
    }
    
    func getCurrentTime() -> TimeInterval {
        return audioPlayer?.currentTime ?? 0
    }

    func getDuration() -> TimeInterval {
        return audioPlayer?.duration ?? 0
    }
}
