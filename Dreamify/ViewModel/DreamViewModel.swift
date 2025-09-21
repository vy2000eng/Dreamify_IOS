//
//  DreamViewModel.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/13/25.
//

import Foundation


class DreamViewModel{
    private var dream:Dream
    private var isPlaying:Bool
    private var isOpen:Bool
    private var isShowingTranscriptionOrAnalysis:Bool
    
    
    init(dream: Dream) {
        self.dream = dream
        self.isOpen = false
        self.isPlaying = false
        self.isShowingTranscriptionOrAnalysis = false
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
    var transcribedText:String{
        dream.transcribedText ?? "There is no transcribed text for this recording"
    }
    
    var analyzedText:String{
        dream.analyzedText ?? "The Analysis has not been done yet"
    }
    

    func toggleIsOpen(){
        self.isOpen = !self.isOpen
        
    }
    
    func retrieveIsOpen() -> Bool{
        return self.isOpen
        
    }
    
    func retrieveIsShowingTextTranscriptionOrAnalysis() -> Bool{
        return self.isShowingTranscriptionOrAnalysis;
    }
    
    func toggleIsShowingTextTransctiptionOrAnalysis(){
        self.isShowingTranscriptionOrAnalysis = !self.isShowingTranscriptionOrAnalysis
    }
    
    
  
}
