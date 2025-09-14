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
    
    var userLoginState: Bool {
        get {
            return _userLoginState
        }
        set {
            _userLoginState = newValue
            saveLoginState(successful_login: newValue)
        }
    }
    
    private init() {
        // Initialize the backing property directly
        self._userLoginState = UserDefaults.standard.bool(forKey: "IS_USER_LOGGED_IN")
    }
    
    func setLoginState(_ isLoggedIn: Bool) {
        userLoginState = isLoggedIn
    }
    
    private func saveLoginState(successful_login: Bool) {
        UserDefaults.standard.set(successful_login, forKey: "IS_USER_LOGGED_IN")
    }
    
    func logout() {
        userLoginState = false
        TokenManager.shared.clearTokens()
    }
}
