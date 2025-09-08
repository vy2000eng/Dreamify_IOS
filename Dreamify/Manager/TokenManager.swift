//
//  TokenManager.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/3/25.
//

import KeychainAccess

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
    
    func saveAccessToken(_ token: String) {
        keychain["access_token"] = token
    }
    
    func getAccessToken() -> String? {
        return keychain["access_token"]
    }
}
