//
//  TokenManager.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/3/25.
//

import KeychainAccess
import Foundation

class TokenManager {
    static let shared = TokenManager()
    private let keychain = Keychain(service: "com.dreamify.tokens")
    
    private init() {} // Prevents others from creating instances
    
    func saveRefreshToken(_ token: String) {
        keychain["refresh_token"] = token
    }
    
    func getRefreshToken() -> String? {
        return keychain["refresh_token"]
    }
    
//    func setTimeSinceLastAnalysisOrTimeSinceLastRecording(dateTime: Date) {
//        UserDefaults.standard.set(dateTime, forKey: "lastAnalysisTime")
//    }
//
//    func getTimeSinceLastAnalysisOrTimeSinceLastRecording() -> Date? {
//        return UserDefaults.standard.object(forKey: "lastAnalysisTime") as? Date
//    }
    
    func saveIsUserSubscribed(isUserSubscribed:Bool){
        keychain["isUserSubscribed"] = isUserSubscribed ? "true": "false"
        
    }
    
    func getUserSubscribed() -> Bool{
        return keychain["isUserSubscribed"] == "true" ? true : false
        
    }
    
    func saveAccessToken(_ token: String) {
        keychain["access_token"] = token
    }
    
    func saveUserEmail(email: String){
        keychain["user_email"] = email
    }
    
    func saveUserId(userId:String){
        keychain["user_id"] = userId
    }
    
    func getUserId() -> String?{
        return keychain["user_id"]
        
    }
    
    func getUserEmail() -> String?{
        return keychain["user_email"]
        
    }
    
    func getAccessToken() -> String? {
        return keychain["access_token"]
    }
    func clearTokens() -> Void{
        keychain["refresh_token"] = nil
        keychain["access_token"] = nil
        keychain["user_email"] = nil
        keychain["user_id"] = nil
    }
    
    
}
