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
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        
        if let currentPlayIndex = dreamRecordingViewModel.getPlayPauseController().indexThatIsCurrentlyPlaying{
            if (currentPlayIndex == indexPath.section){
                cell.playPauseButton.setImage(UIImage(systemName: "pause",withConfiguration: config), for: .normal)
            }else{
                cell.playPauseButton.setImage(UIImage(systemName: "play" ,withConfiguration: config), for: .normal)
            }
            
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
    func handlePlayPause(_ sender:UIButton)  throws -> Void{
        
        
        
        let indexPath                                  = IndexPath                               (row: 0, section: sender.tag)
        let indexThatIsCurrentlyPlaying                = dreamRecordingViewModel.getSelectedIndex()
        let isTheCurrentlySelectedIndexPlayingRightNow = dreamRecordingViewModel.getIsPlaying    ()
        
        guard let curr_cell = self.collectionView.cellForItem(at: indexPath) as? DreamRecordingViewCell else{
            let alert = UIAlertController(title: "An Unexpected Error Occured",
                                          message: "Item Cannot Be Selected.",//"You tapped the start recording button, but the action failed",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.present(alert, animated: true)
            return
            
        }
        
        let config    = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let dream     = dreamRecordingViewModel.dream(by: indexPath.section)
        
        
        // if it is the same index, so pausing the current recording
        if(dreamRecordingViewModel.getPlayPauseController().indexThatIsCurrentlyPlaying == indexPath.section){
            curr_cell.playPauseButton.setImage(UIImage(systemName: "play", withConfiguration: config), for: .normal)
            //stopAudio()
            do{
                try stopAudio()

                
            }catch let err as NSError{
                
                let alert = UIAlertController(title: "An Unexpected Error Occured",
                                              message: "An error occured when the audio player was attempting to stop",//"You tapped the start recording button, but the action failed",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true)
                return
                
                
            }
            
            dreamRecordingViewModel.setPlayPauseController(dreamViewModel: nil, selectedIndex: nil,isPlaying: false)


            return
            
            
        }
        // if there is nothing playing
        if(!dreamRecordingViewModel.getIsPlaying()){
          
                do{
                    
                    
                    curr_cell.playPauseButton.setImage(UIImage(systemName: "pause", withConfiguration: config), for: .normal)
                    dreamRecordingViewModel.setPlayPauseController(dreamViewModel: dream, selectedIndex: indexPath.section,isPlaying: true)
                    let url = dream.url//URL(string: dream.url)
                    try     self.playAudio(fileName: url)
                    

                }catch let err as NSError{
                
                    curr_cell.playPauseButton.setImage(UIImage(systemName: "play", withConfiguration: config), for: .normal)
                    //self.stopAudio()
                    do{
                        try stopAudio()

                        
                    }catch let err as NSError{
                        let alert = UIAlertController(title: "An Unexpected Error Occured",
                                                      message: "An error occured when the audio player was attempting to stop",//"You tapped the start recording button, but the action failed",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                        self.present(alert, animated: true)
                        return
                        
                        
                    }
                    
                    
                    print(err.localizedDescription)
                    let alert = UIAlertController(title: "An Unexpected Error Occured",
                                                  message: "Issue with audio player please try again later.",//"You tapped the start recording button, but the action failed",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.present(alert, animated: true)

                    
                    
                }
            

            return
            
            
        }
        //if smthing is playing, but another recording is selected
        else{
            let prevPlayDetails = dreamRecordingViewModel.getPlayPauseController()
            guard let currentPlayingIndex = prevPlayDetails.indexThatIsCurrentlyPlaying else{
                let alert = UIAlertController(title: "An Unexpected Error Occured",
                                              message: "Cannot Be Played at this time.",//"You tapped the start recording button, but the action failed",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true)
                return
            }
            
            guard let prev_cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: currentPlayingIndex) ) as? DreamRecordingViewCell else{
                let alert = UIAlertController(title: "An Unexpected Error Occured",
                                              message: "Cannot Stop Playing the previous Recording",//"You tapped the start recording button, but the action failed",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true)
                return
                
            }
            
            prev_cell.playPauseButton.setImage(UIImage(systemName: "play", withConfiguration: config), for: .normal)
            do{
                try stopAudio()

                
            }catch let err as NSError{
                let alert = UIAlertController(title: "An Unexpected Error Occured",
                                              message: "An error occured when the audio player was attempting to stop",//"You tapped the start recording button, but the action failed",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true)
                return
                
                
            }
            
            
            
            
            curr_cell.playPauseButton.setImage(UIImage(systemName: "pause", withConfiguration: config), for: .normal)
            dreamRecordingViewModel.setPlayPauseController(dreamViewModel: dream, selectedIndex: indexPath.section,isPlaying: true)
            let url = dream.url
            
            do{
                try  self.playAudio(fileName: url)
                
            }catch{
                curr_cell.playPauseButton.setImage(UIImage(systemName: "play", withConfiguration: config), for: .normal)
                //self.stopAudio()
                do{
                    try stopAudio()

                    
                }catch let err as NSError{
                    let alert = UIAlertController(title: "An Unexpected Error Occured",
                                                  message: "An error occured when the audio player was attempting to stop",//"You tapped the start recording button, but the action failed",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.present(alert, animated: true)
                    return
                    
                    
                }
                
                let alert = UIAlertController(title: "An Unexpected Error Occured",
                                              message: "Issue with audio player please try again later.",//"You tapped the start recording button, but the action failed",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true)
                
                
            }
            return
        }
    }
    
    @objc
    func handleTapGesture(gesture: UITapGestureRecognizer){
        
        if gesture.state == .ended{
            print("tapped")
            guard let id = gesture.view?.tag else {
                fatalError("Developer Error: Tapped An Item that is out of range lol, this shouldn't be possible")
            }
            let dream = dreamRecordingViewModel.dream(by: id)
            
            dream.toggleIsOpen()
            //speechTranscriberManager.transcribeAudio(url: <#T##URL#>)

         
            
            if(dream.retrieveIsOpen()){
                self.collectionView.insertItems(at:[ IndexPath(row: 0, section: id)])
            }else{
                self.collectionView.deleteItems(at:[ IndexPath(row: 0, section: id)])

            }
            
        }
        
    }
    
}
