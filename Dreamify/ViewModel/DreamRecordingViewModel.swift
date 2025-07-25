//
//  File.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/13/25.
//

import Foundation

//struct IsPlayingAllocation{
//    var selectedIndex:Int
//    var isPlaying:Bool
//}
struct PlayPauseController{
        var selectedIndex:Int
        var isPlaying:Bool
}


public class DreamRecordingViewModel{
    
    private var playPauseController:PlayPauseController
    var dreams  = [DreamViewModel]()
    
     var dreamsCount:Int {
        dreams.count
    }
    
    
    init(){
        do{
            self.playPauseController = PlayPauseController(selectedIndex: -1, isPlaying: false)
            try getAllDreams()

        }catch let err as NSError{
            print("Error initializing dreams in init() \(err), \(err.userInfo)")
        }
    }
    func getIsPlaying() -> Bool{
        return self.playPauseController.isPlaying
    }
    
    func getSelectedIndex() -> Int{
        return playPauseController.selectedIndex
        
    }
    func togglePlayPauseButton(selectedIndex:Int){
        
        self.playPauseController.isPlaying = !self.playPauseController.isPlaying
        self.playPauseController.selectedIndex = selectedIndex
        
        dream(by:selectedIndex).setIsPlaying(isPlaying: self.playPauseController.isPlaying)
    }
    
    
    
    func dream(by index:Int) -> DreamViewModel{
        return dreams[index]
    }
    
    func getAllDreams()throws -> Void{
        do{
            dreams = try CoreDataManager.shared.getAllDreams().map(DreamViewModel.init)
        }catch let err as NSError{
            print("Error initializing dreams in getAllDreams() \(err), \(err.userInfo)")
            throw err
        }
    }
    func addDream(url:String, title:String)throws -> Void{
        do{
            try CoreDataManager.shared.addDream(title: title, url: url)
            
        }catch let err as NSError{
            print("Error adding dreams in addDream(url:String, title:String) \(err), \(err.userInfo)")
        }
    }
    
    
    
}
