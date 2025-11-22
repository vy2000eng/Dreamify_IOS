//
//  UserSettings.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/1/25.
//
import Foundation
import UIKit

class UserSettings {
    static let shared = UserSettings()
    
    private var _userLoginState: Bool
    private var _userDetails:UserInfoResponse?
//    private var _userEmail: String?
//    private var _userName: String?
//    private var _createDate:Date?
    
    var userLoginState: Bool {
        get {
            return _userLoginState
        }
        set {
            _userLoginState = newValue
            saveLoginState(successful_login: newValue)
        }
    }
    var userDetails: UserInfoResponse? {  // Make it optional
        get {
            return _userDetails
        }
        set {
            _userDetails = newValue
            saveUserDetails(userDetails: newValue)
        }
    }
    
    private init() {
        // Initialize login state
        self._userLoginState = UserDefaults.standard.bool(forKey: "IS_USER_LOGGED_IN")
        
        // Try to load user details from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "USER_DETAILS"),
           let decoded = try? JSONDecoder().decode(UserInfoResponse.self, from: data) {
            self._userDetails = decoded
        } else {
            self._userDetails = nil  // No saved user details
        }
    }
    
    func setLoginState(_ isLoggedIn: Bool) {
        userLoginState = isLoggedIn
    }
    func setUserDetails(userDetails:UserInfoResponse){
        self.userDetails = userDetails
        
    }
    
    private func saveLoginState(successful_login: Bool) {
        UserDefaults.standard.set(successful_login, forKey: "IS_USER_LOGGED_IN")
    }
    
    private func saveUserDetails(userDetails: UserInfoResponse?) {
        guard let userDetails = userDetails else {
            UserDefaults.standard.removeObject(forKey: "USER_DETAILS")
            return
        }
        
        if let encoded = try? JSONEncoder().encode(userDetails) {
            UserDefaults.standard.set(encoded, forKey: "USER_DETAILS")
        }
    }
    
    func logout() {
        userLoginState = false
        TokenManager.shared.clearTokens()
    }
    
    
    
}
