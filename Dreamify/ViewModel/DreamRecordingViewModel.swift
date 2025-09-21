//
//  File.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/13/25.
//

import Foundation


public class DreamRecordingViewModel{
    
    private var playPauseController:PlayPauseController
    weak var presentErrIfAnalysisFailsDelagate:PresentErrIfAnalysisFails?
    var controllerManagedByDataSource: ControllerManagedByAudioPlayerClass
    var dreams  = [DreamViewModel]()
    
     var dreamsCount:Int {
        dreams.count
    }
    
    
    init(controllerManagedByDataSource:ControllerManagedByAudioPlayerClass? = nil){
        
        self.controllerManagedByDataSource = controllerManagedByDataSource ?? .DreamViewController
        self.playPauseController = PlayPauseController(dream: nil, isPlaying: false,indexThatIsCurrentlyPlaying: nil)

        do{
            
            switch(self.controllerManagedByDataSource){
                
            case .DreamViewController:
                try getAllDreams()
                break

            case .CalendarViewController:
                try getAllDreamsCreatedByDate(seleectedDate: Date.now)
                break
            }
            

        }catch let err as NSError{
            print("Error initializing dreams in init() \(err), \(err.userInfo)")
        }
    }
    func getIsPlaying() -> Bool{
        return self.playPauseController.isPlaying
    }
    
    func getSelectedIndex() -> Int?{
        return playPauseController.indexThatIsCurrentlyPlaying
        
        
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

        var previousTranscribedStates:[String:Bool] = [:]

        for (_, dream) in dreams.enumerated(){
            previousOpenStates[dream.id.uuidString] = dream.retrieveIsOpen()
            previousTranscribedStates[dream.id.uuidString] = dream.retrieveIsShowingTextTranscriptionOrAnalysis()
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
            if previousTranscribedStates[dream.id.uuidString] == true{
                dream.toggleIsShowingTextTransctiptionOrAnalysis()
            }
            
        }
        
    }
    func getAllDreamsCreatedByDate(seleectedDate:Date) throws -> Void {
        do{
            
            try getAllDreams()
            // Get start and end of the selected day
                  let calendar = Calendar.current
                  let startOfDay = calendar.startOfDay(for: seleectedDate)
                  let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
                  
                  // Filter dreams created within that day
                  dreams = dreams.filter { dream in
                      return dream.createdDate >= startOfDay && dream.createdDate < endOfDay
                  }
            //return dreams


            
        }catch let err as NSError{
            print("Error initializing dreams in getAllDreams() \(err), \(err.userInfo)")
            throw err
            
        }
        
        
    }
    func hasDreamsForDate(date: Date) -> Bool {
        do {
            var curr_dreams = dreams
            try getAllDreams()
            var all_dreams = dreams
            dreams = curr_dreams
            
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            return all_dreams.contains { dream in
                return dream.createdDate >= startOfDay && dream.createdDate < endOfDay
            }
            
        } catch {
            print("Error checking dreams for date: \(error)")
            return false
        }
    }
    
    
    func analyzeDream(dreamViewModel: DreamViewModel, completion: @escaping (Result<AnalysisRespone, APIError>) -> Void) {
        APIClientManager.shared.authRequest(
            endpoint: "/Analysis/analyzeDream",
            method: "POST",
            body: ["textToAnalyze": dreamViewModel.transcribedText],
            type: AnalysisRespone.self
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                updateAnalyzedText(dreamId: dreamViewModel.id, analyzedText: response.dreamAnalysisResponse)
                completion(.success(response))
                
            case .failure(let err):
                let (title, message) = getErrorMessage(for: err)
                presentErrIfAnalysisFailsDelagate?.presentUiAlertErr(title: title, errMessage: message)
                completion(.failure(err))
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
    
}
