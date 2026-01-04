//
//  DataSourceUtils.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 1/4/26.
//

import UIKit
class DreamRecordingViewDataSourceManagerUtils{
    private init(){}
    
    static func createAlert(title:String, message:String) ->UIAlertController{
        let alert = UIAlertController(title: title,
                                      message: message,//"You tapped the start recording button, but the action failed",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        return alert
        
        
        
    }
    
    
    
    
    
    
}
