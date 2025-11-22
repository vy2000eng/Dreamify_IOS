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
                TokenManager.shared.clearTokens()
                accountManagerView.changeAccountSection()

                return
            }
            if(itemTitle == "Create An Account"){
                var loginViewController = LoginViewController()
                loginViewController.userIsLoggedInChangeAccountMAnagementOptionsDelegate = self
                self.navigationController?.pushViewController(loginViewController, animated: true)
                return
            }
        
            
            if(itemTitle == "Log Out"){
                TokenManager.shared.clearTokens()
            }
            if(itemTitle == "Manage Account"){
                var userInfo = UserInfoViewController()
                
                
                
                
               // userInfo.retrieveUserInfo()
                //loginViewController.userIsLoggedInChangeAccountMAnagementOptionsDelegate = self
                self.navigationController?.pushViewController(userInfo, animated: true)
                return
                
            }
            
            
            if(itemTitle == "Privacy Policy"){
                var privacyPolicyViewController = PrivacyPolicyTermsOfServiceController(privacyPolicyTermsOfService: 0)
                
                self.navigationController?.pushViewController(privacyPolicyViewController, animated: true)
                return
            }
            if(itemTitle == "Terms of Service"){
                var privacyPolicyViewController = PrivacyPolicyTermsOfServiceController(privacyPolicyTermsOfService: 1)
                
                self.navigationController?.pushViewController(privacyPolicyViewController, animated: true)
                return
            }
        }
        
    }
    

    
    
    
    
    
    
    
    
    
    
}
