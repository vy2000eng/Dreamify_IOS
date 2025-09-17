//
//  DreamRecordingViewControllerCollectionViewDataSource.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//

import UIKit

//extension DreamRecordingsViewController:UICollectionViewDataSource{
class DreamRecordingViewDataSourceManager:NSObject,UICollectionViewDataSource{
    var dreamRecordingViewModel:DreamRecordingViewModel
    var dreamRecordingsView:DreamRecordsView
    var controller:UIViewController
    var audioPlayerManager: AudioPlayerManager
    var controllerManagedByAudioPlayer:ControllerManagedByAudioPlayerClass
    //var controller:UIViewController!
    
    init(dreamRecordingView:DreamRecordsView, dreamRecordingViewModel:DreamRecordingViewModel,controller:UIViewController) {
        self.controller = controller
        
        self.dreamRecordingsView = dreamRecordingView
        self.dreamRecordingViewModel = dreamRecordingViewModel
        // Cleaner type checking
        switch controller {
        case is DreamRecordingsViewController:
            controllerManagedByAudioPlayer = .DreamViewController
        case is CalendarViewController:
            controllerManagedByAudioPlayer = .CalendarViewController
        default:
            fatalError("Unsupported controller type")
            
            
        }
        
        
        self.audioPlayerManager = AudioPlayerManager(
            viewcontroller: controller,
            viewmodel: dreamRecordingViewModel,
            controllerManagedByAudioPlayer: controllerManagedByAudioPlayer
        )
        
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dreamCell(indexPath:IndexPath) -> UICollectionViewCell{
        guard let cell = dreamRecordingsView.collectionView.dequeueReusableCell(withReuseIdentifier: "dreamCell", for: indexPath) as? DreamRecordingViewCell
        else{
            fatalError("Unable to dequeue TopicViewCell. This is a developer error.")
        }
        let dream = dreamRecordingViewModel.dream(by: indexPath.section)
        cell.configure(with: dream)
        cell.playPauseButton.tag    = indexPath.section
        cell.playPauseButton.addTarget(self, action: #selector(handlePlayPause( _:)) , for: .touchUpInside)
        
        cell.analyzeButton.tag    = indexPath.section
        cell.analyzeButton.addTarget(self, action: #selector(analyzeDream(_:)), for: .touchUpInside)
        
        cell.transcriptionAnalysisButton.tag = indexPath.section
        cell.transcriptionAnalysisButton.addTarget(self, action: #selector(handleAnalysisTranscriptionButton), for: .touchUpInside)
        
        
        
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

extension DreamRecordingViewDataSourceManager{
    @objc
    func handlePlayPause(_ sender:UIButton)  throws -> Void{
        
        
        
        let indexPath                                  = IndexPath                               (row: 0, section: sender.tag)
        let indexThatIsCurrentlyPlaying                = dreamRecordingViewModel.getSelectedIndex()
        let isTheCurrentlySelectedIndexPlayingRightNow = dreamRecordingViewModel.getIsPlaying    ()
        
        guard let curr_cell = dreamRecordingsView.collectionView.cellForItem(at: indexPath) as? DreamRecordingViewCell else{
            let alert = UIAlertController(title: "An Unexpected Error Occured",
                                          message: "Item Cannot Be Selected.",//"You tapped the start recording button, but the action failed",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            
            //viewCon
            
            
            self.controller.present(alert, animated: true)
            return
            
        }
        
        let config    = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let dream     = dreamRecordingViewModel.dream(by: indexPath.section)
        
        
        // if it is the same index, so pausing the current recording
        if(dreamRecordingViewModel.getPlayPauseController().indexThatIsCurrentlyPlaying == indexPath.section){
            curr_cell.playPauseButton.setImage(UIImage(systemName: "play", withConfiguration: config), for: .normal)
            //stopAudio()
            do{
                try self.audioPlayerManager.stopAudio()

                
            }catch let err as NSError{
                
                let alert = UIAlertController(title: "An Unexpected Error Occured",
                                              message: "An error occured when the audio player was attempting to stop",//"You tapped the start recording button, but the action failed",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.controller.present(alert, animated: true)
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
                    try     self.audioPlayerManager.playAudio(fileName: url)
                    

                }catch let err as NSError{
                
                    curr_cell.playPauseButton.setImage(UIImage(systemName: "play", withConfiguration: config), for: .normal)
                    //self.stopAudio()
                    do{
                        try self.audioPlayerManager.stopAudio()

                        
                    }catch let err as NSError{
                        let alert = UIAlertController(title: "An Unexpected Error Occured",
                                                      message: "An error occured when the audio player was attempting to stop",//"You tapped the start recording button, but the action failed",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                        self.controller.present(alert, animated: true)
                        return
                        
                        
                    }
                    
                    
                    print(err.localizedDescription)
                    let alert = UIAlertController(title: "An Unexpected Error Occured",
                                                  message: "Issue with audio player please try again later.",//"You tapped the start recording button, but the action failed",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.controller.present(alert, animated: true)

                    
                    
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
                self.controller.present(alert, animated: true)
                return
            }
            
            guard let prev_cell = dreamRecordingsView.collectionView.cellForItem(at: IndexPath(row: 0, section: currentPlayingIndex) ) as? DreamRecordingViewCell else{
                let alert = UIAlertController(title: "An Unexpected Error Occured",
                                              message: "Cannot Stop Playing the previous Recording",//"You tapped the start recording button, but the action failed",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.controller.present(alert, animated: true)
                return
                
            }
            
            prev_cell.playPauseButton.setImage(UIImage(systemName: "play", withConfiguration: config), for: .normal)
            do{
                try self.audioPlayerManager.stopAudio()

                
            }catch let err as NSError{
                let alert = UIAlertController(title: "An Unexpected Error Occured",
                                              message: "An error occured when the audio player was attempting to stop",//"You tapped the start recording button, but the action failed",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.controller.present(alert, animated: true)
                return
                
                
            }
            
            
            
            
            curr_cell.playPauseButton.setImage(UIImage(systemName: "pause", withConfiguration: config), for: .normal)
            dreamRecordingViewModel.setPlayPauseController(dreamViewModel: dream, selectedIndex: indexPath.section,isPlaying: true)
            let url = dream.url
            
            do{
                try  self.audioPlayerManager.playAudio(fileName: url)
                
            }catch{
                curr_cell.playPauseButton.setImage(UIImage(systemName: "play", withConfiguration: config), for: .normal)
                //self.stopAudio()
                do{
                    try self.audioPlayerManager.stopAudio()

                    
                }catch let err as NSError{
                    let alert = UIAlertController(title: "An Unexpected Error Occured",
                                                  message: "An error occured when the audio player was attempting to stop",//"You tapped the start recording button, but the action failed",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.controller.present(alert, animated: true)
                    return
                    
                    
                }
                
                let alert = UIAlertController(title: "An Unexpected Error Occured",
                                              message: "Issue with audio player please try again later.",//"You tapped the start recording button, but the action failed",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.controller.present(alert, animated: true)
                
                
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
            print("id of tapped item:\(id)")

            let dream = dreamRecordingViewModel.dream(by: id)
            
            dream.toggleIsOpen()
            //speechTranscriberManager.transcribeAudio(url: <#T##URL#>)

         
            
            if(dream.retrieveIsOpen()){
                dreamRecordingsView.collectionView.insertItems(at:[ IndexPath(row: 0, section: id)])
            }else{
                dreamRecordingsView.collectionView.deleteItems(at:[ IndexPath(row: 0, section: id)])

            }
            
        }
        
    }
    @objc
    func analyzeDream(_ sender:UIButton) {
        print("analyzze tapped")
        let indexPath = IndexPath (row: 0, section: sender.tag)
        let dream    = dreamRecordingViewModel.dream(by: indexPath.section)
        
        let loading = LoadingOverlayView(
               title: "Analyzing dream...",
               subtitle: "Please wait while we analyze your dream"
           )
        loading.show(in: self.controller.view)
        
        
        dreamRecordingViewModel.analyzeDream(dreamViewModel: dream) { [weak self] result in
            guard let self = self else{return}
              DispatchQueue.main.async {
                  loading.hide()
                  
                  switch result {
                  case .success(_):
                      guard let curr_cell = self.dreamRecordingsView.collectionView.cellForItem(at: indexPath) as? DreamRecordingViewCell else{
                          let alert = UIAlertController(title: "An Unexpected Error Occured",
                                                        message: "Item Cannot Be Selected.",//"You tapped the start recording button, but the action failed",
                                                        preferredStyle: .alert)
                          alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                          self.controller.present(alert, animated: true)
                          return
                          
                          
                      }
                      curr_cell.transcriptionAnalysisButton.setTitle("Analysis", for: .normal)
                      curr_cell.transcriptionAnalysisButton.backgroundColor = .systemOrange
                      curr_cell.textView.attributedText =  .create(
                          string: dream.analyzedText,
                          font: .systemFont(ofSize: 16, weight: .regular),
                          color: .label
                      )
                      dream.toggleIsShowingTextTransctiptionOrAnalysis()
                      self.dreamRecordingsView.collectionView.reloadItems(at: [indexPath])


                      
                      print("Analysis completed successfully")
                      // Optionally refresh your collection view or show success message
                      
                  case .failure(_):
                      // Error is already handled by the delegate in the view model
                      UserSettings.shared.setLoginState(false)
                      
                      let loginViewController = LoginViewController()
                      
                      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                         let window = windowScene.windows.first {
                          window.rootViewController = UINavigationController(rootViewController: loginViewController)
                          window.makeKeyAndVisible()
                      }
                      
                      print("Analysis failed")
                  }
              }
          }
        
       // do{
        //dreamRecordingViewModel.analyzeDream(dreamViewModel: dream)
        
            
//        }catch let err as NSError{
//            let alert = UIAlertController(title: "An Unexpected Error Occured",
//                                          message: err.localizedDescription,//"You tapped the start recording button, but the action failed",
//                                          preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
//            self.present(alert, animated: true)
//                
//        }
        
        


        
        
        
        
    }
    
    @objc
    func handleAnalysisTranscriptionButton(_ sender:UIButton){
        let indexPath = IndexPath (row: 0, section: sender.tag)
        let dream = dreamRecordingViewModel.dream(by: indexPath.section)
        
        guard let curr_cell = dreamRecordingsView.collectionView.cellForItem(at: indexPath) as? DreamRecordingViewCell else{
            let alert = UIAlertController(title: "An Unexpected Error Occured",
                                          message: "Item Cannot Be Selected.",//"You tapped the start recording button, but the action failed",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.controller.present(alert, animated: true)
            return
            
        }
        
        
        //dream.toggleIsShowingTextTransctiptionOrAnalysis()
        if(dream.retrieveIsShowingTextTranscriptionOrAnalysis()){
            curr_cell.transcriptionAnalysisButton.setTitle("Transcription", for: .normal)
            curr_cell.transcriptionAnalysisButton.backgroundColor = .systemCyan
            curr_cell.textView.attributedText =  .create(
                string: dream.transcribedText,
                font: .systemFont(ofSize: 16, weight: .regular),
                color: .label
            )
            
          

        }else{
            curr_cell.transcriptionAnalysisButton.setTitle("Analysis", for: .normal)
            curr_cell.transcriptionAnalysisButton.backgroundColor = .systemOrange
            curr_cell.textView.attributedText =  .create(
                string: dream.analyzedText,
                font: .systemFont(ofSize: 16, weight: .regular),
                color: .label
            )
         

            
        }
        dream.toggleIsShowingTextTransctiptionOrAnalysis()

        
        dreamRecordingsView.collectionView.reloadItems(at: [indexPath])

        
        
    }
    
}
