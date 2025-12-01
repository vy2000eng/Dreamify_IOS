//
//  UserViewModel.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/26/25.
//
import UIKit
import Foundation

class UserEntityViewModel{
    
    var user : UserEntityModel?//[UserEntityModel]()
    
    
    init(email:String?)throws {
        //if user does not exist
        guard let userEmail = email else {
            return
        }
        
        do{
            
            self.user = try getUserByEmail(email: userEmail)

            
        }catch let error as NSError{
            throw NSError(domain: "UserEntityViewModel ctor", code: 1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
        }
        
        
    }
    
    
     func getUserByEmail(email:String) throws -> UserEntityModel{
        do{
            
           let user = try  CoreDataManager.shared.getUserByEmail(email: email)
            return user
        }catch let error as NSError{
            do {
                let newUser = try CoreDataManager.shared.addUser(email: email)
                return newUser
            } catch let createError as NSError {
                throw NSError(domain: "UserEntityViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to create user in internal database: \(createError.localizedDescription)"])
            }
         //   throw NSError(domain: "UserEntityViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve user from internal database"])
        }
        
        
        
    }
    
    func addUser(email:String)throws -> UserEntityModel{
        do{
            return try CoreDataManager.shared.addUser(email: email)

            
        }catch let err as NSError{
            throw NSError(domain: "UserEntityViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to add user to internal database"])

            
        }
       // let userEntityModel = Us
        
    }
    
    
    
}
