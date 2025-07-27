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


public class DreamRecordingViewModel{
    
    private var playPauseController:PlayPauseController
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
    
    func addDream(url:String, title:String)throws -> Void{
        do{
            try CoreDataManager.shared.addDream(title: title, url: url)
            
            try getAllDreams()
            
            
        }catch let err as NSError{
            print("Error adding dreams in addDream(url:String, title:String) \(err), \(err.userInfo)")
        }
    }
}
