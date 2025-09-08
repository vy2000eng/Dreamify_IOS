//
//  File.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/13/25.
//

import Foundation

struct PlayPauseController{
    var dream:DreamViewModel?
    var isPlaying:Bool
    var indexThatIsCurrentlyPlaying:Int?

        
}

protocol PresentErrIfAnalysisFails:AnyObject{
    func presentUiAlertErr(title:String, errMessage:String) -> Void
}
//weak var :PresentErrIfAnalysisFails?






public class DreamRecordingViewModel{
    
    private var playPauseController:PlayPauseController
    weak var presentErrIfAnalysisFailsDelagate:PresentErrIfAnalysisFails?

   // private var SpeechTranscriberManager:SpeeachTranscriberManager!
    var dreams  = [DreamViewModel]()
    
     var dreamsCount:Int {
        dreams.count
    }
    
    
    init(){
        do{
            self.playPauseController = PlayPauseController(dream: nil, isPlaying: false,indexThatIsCurrentlyPlaying: nil)
            try getAllDreams()

        }catch let err as NSError{
            print("Error initializing dreams in init() \(err), \(err.userInfo)")
        }
    }
    func getIsPlaying() -> Bool{
        return self.playPauseController.isPlaying
    }
    
    func getSelectedIndex() -> Int?{
        return playPauseController.indexThatIsCurrentlyPlaying
        
        //return playPauseController.selectedIndex
        
    }
    
    func setPlayPauseController(dreamViewModel:DreamViewModel?, selectedIndex:Int?,isPlaying:Bool){
        self.playPauseController = PlayPauseController(dream: dreamViewModel, isPlaying: isPlaying,indexThatIsCurrentlyPlaying: selectedIndex)
        
    }
    func getPlayPauseController()->PlayPauseController{
        return self.playPauseController
    }
    
    func updateInternalPlayPauseButtonByIndex(index:Int){
        let dream = dream(by: index)
        dream.setIsPlaying(isPlaying: !dream.getIsPlaying())
        
        

        
    }
    
    
    
    func dream(by index:Int) -> DreamViewModel{
        return dreams[index]
    }
    
    func getAllDreams()throws -> Void{
        var previousOpenStates:[String:Bool] = [:]
        
        for (_, dream) in dreams.enumerated(){
            previousOpenStates[dream.id.uuidString] = dream.retrieveIsOpen()
        }
    
        do{
            
            dreams = try CoreDataManager.shared.getAllDreams().map(DreamViewModel.init )
            
        }catch let err as NSError{
            print("Error initializing dreams in getAllDreams() \(err), \(err.userInfo)")
            throw err
        }
        
        for dream in dreams{
            if previousOpenStates[dream.id.uuidString] == true{
                dream.toggleIsOpen()
            }
            
        }
        
    }
    
    func analyzeDream(dreamViewModel: DreamViewModel) {
        
        APIClientManager.shared.authRequest(
       
            endpoint: "/Analysis/analyzeDream",
            method: "POST",
            body:["textToAnalyze": dreamViewModel.transcribedTest],
            type: AnalysisRespone.self){[weak self] result in
                guard let self  = self else {return}
                switch result{
                case .success(let response):
                    print(response.dreamAnalysisResponse)
                    updateAnalyzedText(dreamId: dreamViewModel.id, analyzedText: response.dreamAnalysisResponse)
                    
                case .failure(let err):
                    let (title, message) = getErrorMessage(for: err)
                    presentErrIfAnalysisFailsDelagate?.presentUiAlertErr(title: title, errMessage: message)

                    
                   // print(err.localizedDescription)
                }
                
            }
    }
    private func getErrorMessage(for error: APIError) -> (String, String) {
        switch error {
        case .networkError:
            return ("Network Error", "Please check your internet connection and try again.")
        case .serverError(let code):
            return ("Server Error", "Server returned error code: \(code). Please try again later.")
        case .noData:
            return ("No Data", "No response received from server.")
        case .decodingError:
            return ("Data Error", "Unable to process server response.")
        case .invalidURL:
            return ("Invalid Url", "Unable to process server response.")

        case .authenticationError:
            return ("Authentication Error", "Unable to process server response.")

        }
    }
    
    func updateAnalyzedText(dreamId: UUID, analyzedText:String){
        CoreDataManager.shared.updateAnalyzedTextForDream(analyzedText: analyzedText, dreamId: dreamId)
        
    }
    
    
    func addDream(url:String, title:String, transcribedText:String?)throws -> Void{
        do{
            try CoreDataManager.shared.addDream(title: title, url: url,transribedText: transcribedText)
            
            try getAllDreams()
            
            
        }catch let err as NSError{
            print("Error adding dreams in addDream(url:String, title:String) \(err), \(err.userInfo)")
        }
    }
    
    func addDreamWithNoTextTranscription(url:String, title:String, transcribedText:String)throws -> Void{
        do{
            try CoreDataManager.shared.addDream(title: title, url: url,transribedText: transcribedText)
            
            try getAllDreams()
            
            
        }catch let err as NSError{
            print("Error adding dreams in addDream(url:String, title:String) \(err), \(err.userInfo)")
        }
    }
    
    func transcribeAudioFile(){
        
    }
}
