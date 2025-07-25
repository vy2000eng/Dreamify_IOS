//
//  DreamViewModel.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/13/25.
//

import Foundation

//struct IsPlayingAllocation{
//    var selectedIndex:Int
//    var isPlaying:Bool
//}

class DreamViewModel{
    private var dream:Dream
    private var isPlaying:Bool
   // private var sizeIndexAllocation:IsPlayingAllocation
    private var isOpen:Bool
    
    
    init(dream: Dream) {
        //self.sizeIndexAllocation = IsPlayingAllocation(selectedIndex: -1, isPlaying: false)
       // self.isPlaying = false
        self.dream = dream
        self.isOpen = false
        self.isPlaying = false
    }
    var id:UUID{
        dream.id
    }
    func setIsPlaying(isPlaying: Bool){
        self.isPlaying = isPlaying
    }
    func getIsPlaying()->Bool{
        return self.isPlaying
    }
    var createdDate:Date{
        dream.created_date ?? Date()
    }
    var title:String{
        dream.title ?? "title is not defined"
    }
    var url:String{
        dream.url ?? "url path is not defined"
    }
    

    func toggleIsOpen(){
        self.isOpen = !self.isOpen
        
    }
    
    func retrieveIsOpen() -> Bool{
        return self.isOpen
        
    }
}
