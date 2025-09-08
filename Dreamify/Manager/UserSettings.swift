//
//  UserSettings.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/1/25.
//
import Foundation
import UIKit

class UserSettings{
    static let shared = UserSettings()
    
    
    
    private(set) var userLoginState:Bool{
        didSet{
            saveLoginState(successful_loging: false)

        }
        
    }
    
    
    private init(){
        self.userLoginState = false
        //saveLoginState()
        if let loadedUserLoginState =  loadUserLogInState(){
            self.userLoginState = loadedUserLoginState
            
            
        }
        
    }
    
    
    
    private func saveLoginState(successful_loging:Bool) {
        //viewmodel.selectedTheme = selectedTheme
        UserDefaults.standard.set(successful_loging, forKey: "IS_USER_LOGGED_IN")
        
    }
    
    private func loadUserLogInState() ->Bool?{

        return UserDefaults.standard.object(forKey: "IS_USER_LOGGED_IN") as? Bool//viewmodel.convertThemeDmViewModelToDefinedThemeObject(themeID: viewmodel.themeViewModel[0].id)
        
    }
    
    
    
    
    
    
}
