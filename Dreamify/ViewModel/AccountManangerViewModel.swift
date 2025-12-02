//
//  AccountManangerViewModel.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 12/1/25.
//

import Foundation
import UIKit

class AccountManangerViewModel {
    
    func deleteAllData() throws -> Void{
        
        do{
            guard let userEmail = TokenManager.shared.getUserEmail() else {
                throw NSError(domain:"User email not stored ", code: 1, userInfo: [NSLocalizedDescriptionKey: "Dream not found"])
            }
            
            
            try CoreDataManager.shared.deleteAllDataForUser(email: userEmail)
            
            
            
            
        }catch let err as NSError{
            throw NSError(domain: err.domain, code: err.code, userInfo: err.userInfo)
        }
        
      
    }
    
    
    
}
