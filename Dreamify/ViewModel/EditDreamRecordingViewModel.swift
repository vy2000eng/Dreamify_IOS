//
//  EditDreamRecordingViewModel.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/22/25.
//

import UIKit

public class EditDreamRecordingViewModel{
    var dream:DreamViewModel
    init (dream:DreamViewModel) {
        self.dream = dream
        
    }
    //TODO: all instances which are accesing core data should throw
    func updateDream(dreamTitle: String? = nil, dreamTranscription: String? = nil){
        CoreDataManager.shared.updateDream(dreamId: self.dream.id,dreamTitle: dreamTitle, dreamTranscription: dreamTranscription )
    }
    
    
    
    
    
    
}
