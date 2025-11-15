//
//  DreamRecordingViewControllerCollectionViewDataSource.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//

import UIKit
class DreamRecordingViewDataSourceManager:NSObject,UICollectionViewDataSource{
    var dreamRecordingViewModel:DreamRecordingViewModel
    //var dreamRecordingsView:DreamRecordsView
    var controller:UIViewController
    var audioPlayerManager: AudioPlayerManager
    var controllerManagedByAudioPlayer:ControllerManagedByAudioPlayerClass
   
    weak var retrieveCurrentlySelectedDateDelegate:RetrieveCurrentlySelectedDate?
    weak var deleteSectionFromCollectionViewDelegateInCalendarViewController:DeleteSectionFromCollectionView?
    weak var deleteSectionFromCollectionViewInDreamViewControllerDelegate:DeleteSectionFromCollectionView?
    
    init(dreamRecordingView:DreamRecordsView, dreamRecordingViewModel:DreamRecordingViewModel,controller:UIViewController) {
        self.controller = controller
        
        //self.dreamRecordingsView = dreamRecordingView
        self.dreamRecordingViewModel = dreamRecordingViewModel
        // Cleaner type checking
        switch controller {
        case is DreamRecordingsViewController:
            self.controller =  self.controller as! DreamRecordingsViewController
            controllerManagedByAudioPlayer = .DreamViewController
            break
        case is CalendarViewController:
            self.controller =  self.controller as! CalendarViewController

            controllerManagedByAudioPlayer = .CalendarViewController
            break
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
        print("index path at which the cell is being returned is: [\(indexPath.row),\(indexPath.section)]")
        guard let cell = dreamRecordingsView.collectionView.dequeueReusableCell(withReuseIdentifier: "dreamCell", for: indexPath) as? DreamRecordingViewCell
        
        else{
            fatalError("Unable to dequeue TopicViewCell. This is a developer error.")
        }
        let dream = dreamRecordingViewModel.dream(by: indexPath.row)
        cell.configure(with: dream)
        cell.playPauseButton.tag    = indexPath.row
        cell.playPauseButton.addTarget(self, action: #selector(handlePlayPause( _:)) , for: .touchUpInside)
        
        cell.analyzeButton.tag    = indexPath.row
        cell.analyzeButton.addTarget(self, action: #selector(analyzeDream(_:)), for: .touchUpInside)
        
        cell.transcriptionAnalysisButton.tag = indexPath.row
        cell.transcriptionAnalysisButton.addTarget(self, action: #selector(handleAnalysisTranscriptionButton), for: .touchUpInside)
        
        
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        
        if let currentPlayIndex = dreamRecordingViewModel.getPlayPauseController().indexThatIsCurrentlyPlaying{
            if (currentPlayIndex == indexPath.row){
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
        
        return dreamCell(indexPath: indexPath)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped item at \(indexPath.row)")
        let dream = dreamRecordingViewModel.dream(by: indexPath.row)
        if(dreamRecordingViewModel.previouslyOpenedDreamId == indexPath.row){
            dream.toggleIsOpen()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                collectionView.performBatchUpdates({
                    collectionView.reloadItems(at: [indexPath])
                }, completion: nil)
            }
            return
            
        }
        
        
        //if there are no open dreams
        if(dreamRecordingViewModel.previouslyOpenedDreamId == nil){
            dreamRecordingViewModel.previouslyOpenedDreamId = indexPath.row
            dream.toggleIsOpen()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                collectionView.performBatchUpdates({
                    collectionView.reloadItems(at: [indexPath])
                }, completion: nil)
            }
            return
        }
        //if there is an open dream
        //1.) close the first one
        //2.) open the second one
        else{
            guard let previosulyOpenDreamID = dreamRecordingViewModel.previouslyOpenedDreamId else {
                
                dream.toggleIsOpen()
                dreamRecordingViewModel.previouslyOpenedDreamId = indexPath.row
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    collectionView.performBatchUpdates({
                        collectionView.reloadItems(at: [indexPath])
                    }, completion: nil)
                }
                return
            }
            var previouslyOpenedDream = dreamRecordingViewModel.dream(by: previosulyOpenDreamID)
            previouslyOpenedDream.toggleIsOpen()
            dream.toggleIsOpen()
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveLinear],
                animations: {
                    collectionView.performBatchUpdates({
                        collectionView.reloadItems(at: [
                            IndexPath(row: previosulyOpenDreamID, section: 0),
                            indexPath
                        ])
                    }, completion: nil)
                    collectionView.layoutIfNeeded()
                }
            )
            dreamRecordingViewModel.previouslyOpenedDreamId = indexPath.row
            return
            
        }
        
    }
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dreamRecordingViewModel.dreamsCount
        

        
    }
    
    

}

extension DreamRecordingViewDataSourceManager{
    @objc
    func handlePlayPause(_ sender:UIButton)  throws -> Void{
        
        
        
        let indexPath                                  = IndexPath                               (row: sender.tag, section: 0)
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
        let dream     = dreamRecordingViewModel.dream(by: indexPath.row)
        
        
        // if it is the same index, so pausing the current recording
        if(dreamRecordingViewModel.getPlayPauseController().indexThatIsCurrentlyPlaying == indexPath.row){
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
                    dreamRecordingViewModel.setPlayPauseController(dreamViewModel: dream, selectedIndex: indexPath.row,isPlaying: true)
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
            
            guard let prev_cell = dreamRecordingsView.collectionView.cellForItem(at: IndexPath(row: currentPlayingIndex, section: 0) ) as? DreamRecordingViewCell else{
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
            dreamRecordingViewModel.setPlayPauseController(dreamViewModel: dream, selectedIndex: indexPath.row,isPlaying: true)
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

         
            
            if(dream.retrieveIsOpen()){
                dreamRecordingsView.collectionView.insertItems(at:[ IndexPath(row: id, section: 0)])
            }else{
                dreamRecordingsView.collectionView.deleteItems(at:[ IndexPath(row: id, section: 0)])

            }
            
        }
        
    }
    @objc
    func analyzeDream(_ sender:UIButton) {
        print("analyzze tapped")
        let indexPath = IndexPath (row: sender.tag, section: 0)
        let dream    = dreamRecordingViewModel.dream(by: indexPath.row)
        
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
        
        
        


        
        
        
        
    }
    
    @objc
    func handleAnalysisTranscriptionButton(_ sender:UIButton){
        let indexPath = IndexPath (row: sender.tag, section: 0)
        let dream = dreamRecordingViewModel.dream(by: indexPath.row)
        
        guard let curr_cell = dreamRecordingsView.collectionView.cellForItem(at: indexPath) as? DreamRecordingViewCell else{
            let alert = UIAlertController(title: "An Unexpected Error Occured",
                                          message: "Item Cannot Be Selected.",//"You tapped the start recording button, but the action failed",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.controller.present(alert, animated: true)
            return
            
        }
        

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else {return}
             dreamRecordingsView.collectionView.performBatchUpdates({[weak self] in
                 guard let self = self else {return}
  
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
                 dreamRecordingsView.collectionView.reconfigureItems(at: [indexPath])
             }, completion: nil)
         }
        
        

        

        
        
    }
    
}
