//
//  TabsViewControllerDelegate.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/14/25.
//

import UIKit


extension  TabsViewController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if(viewController.tabBarItem.tag == 2){
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationItem.title = "All Recordings"
            
        }else{
            
            navigationItem.title = ""

            
        }
    }
    
}
