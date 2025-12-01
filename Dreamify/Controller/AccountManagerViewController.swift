//
//  AccountManagerViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/5/25.
//

import UIKit


class AccountManagerViewController: UIViewController, UserIsLoggedInChangeAccountMAnagementOptions {
    func userIsLoggedInChangeAccountMAnagementOptions() {
        accountManagerView.changeAccountSection()
    }
    
    private let accountManagerView = AccountManagerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(accountManagerView)
        accountManagerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            accountManagerView.topAnchor.constraint(equalTo: view.topAnchor),
            accountManagerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accountManagerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accountManagerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Handle item taps
        accountManagerView.onItemTapped = { [weak self] itemTitle in
            guard let self = self else {return}
            print("Tapped: \(itemTitle)")
            if(itemTitle == "Log Out"){
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let window = windowScene.windows.first {
                    let mainViewController = LoginViewController()
                    TokenManager.shared.clearTokens()
                    accountManagerView.changeAccountSection()
                    TokenManager.shared.clearTokens()
                    let loginViewController = LoginViewController()
                    loginViewController.userIsLoggedInChangeAccountMAnagementOptionsDelegate = self
                    window.rootViewController = UINavigationController(rootViewController: mainViewController)
                    window.makeKeyAndVisible()
                }
                return
            }
            if(itemTitle == "Create An Account"){
                let loginViewController = LoginViewController()
                loginViewController.userIsLoggedInChangeAccountMAnagementOptionsDelegate = self
                self.navigationController?.pushViewController(loginViewController, animated: true)
                return
            }
        
            
       
            if(itemTitle == "Manage Account"){
                let userInfo = UserInfoViewController()
                
                
                
                
               // userInfo.retrieveUserInfo()
                //loginViewController.userIsLoggedInChangeAccountMAnagementOptionsDelegate = self
                self.navigationController?.pushViewController(userInfo, animated: true)
                return
                
            }
            
            
            if(itemTitle == "Privacy Policy"){
                let privacyPolicyViewController = PrivacyPolicyTermsOfServiceController(privacyPolicyTermsOfService: 0)
                
                self.navigationController?.pushViewController(privacyPolicyViewController, animated: true)
                return
            }
            if(itemTitle == "Terms of Service"){
                let privacyPolicyViewController = PrivacyPolicyTermsOfServiceController(privacyPolicyTermsOfService: 1)
                
                self.navigationController?.pushViewController(privacyPolicyViewController, animated: true)
                return
            }
            
            if(itemTitle == "Delete All Data"){
                
                
            }
        }
        
    }
    

    
    
    
    
    
    
    
    
    
    
}
