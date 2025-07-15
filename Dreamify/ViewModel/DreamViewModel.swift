//
//  DreamViewModel.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/13/25.
//

import Foundation


class DreamViewModel{
    private var dream:Dream
    init(dream: Dream) {
        self.dream = dream
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
    
}
