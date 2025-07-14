//
//  File.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/13/25.
//

import Foundation



public class DreamRecordingViewModel{
    
    var dreams  = [DreamViewModel]()
    
     var dreamsCount:Int {
        dreams.count
    }
    
    
    init(){
        do{
            try getAllDreams()
        }catch let err as NSError{
            print("Error initializing dreams in init() \(err), \(err.userInfo)")
        }
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
