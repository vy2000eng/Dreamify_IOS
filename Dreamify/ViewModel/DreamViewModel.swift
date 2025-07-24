//
//  DreamViewModel.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/13/25.
//

import Foundation

struct SizeIndexAllocation{
    var selectedIndex:Int
    var isSelected:Bool
}

class DreamViewModel{
    private var dream:Dream
    private var isPlaying:Bool
    private var sizeIndexAllocation:SizeIndexAllocation
    private var isOpen:Bool
    
    
    init(dream: Dream) {
        self.sizeIndexAllocation = SizeIndexAllocation(selectedIndex: -1, isSelected: false)
        self.isPlaying = false
        self.dream = dream
        self.isOpen = false
    }
    var id:UUID{
        dream.id
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
    
    var getIsPlaying:Bool{
        return self.isPlaying
        
    }
    func getSizeIndexAllocationStruct() -> SizeIndexAllocation{
        return self.sizeIndexAllocation
    }
    func setSizeIndexAllocation(isSelected:Bool, selectedIndex:Int){
        self.sizeIndexAllocation = SizeIndexAllocation(selectedIndex: selectedIndex, isSelected: isSelected)
    }
    
    
    func togglePlayPauseButton(){
        self.isPlaying = !self.isPlaying
        
    }
    func toggleIsOpen(){
        self.isOpen = !self.isOpen
        
    }
    
    func retrieveIsOpen() -> Bool{
        return self.isOpen
        
    }
}
