//
//  UserModel.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/26/25.
//

import Foundation

class UserEntityModel{
    private var userEntity:UserEntity
    
    
    
    
    init(userEntity:UserEntity){
        self.userEntity = userEntity

    }
    
    
    
    
    var id: UUID{
        self.userEntity.id
        
    }
    
    var userEmail: String{
        self.userEntity.userEmail
    }

    
    
}
