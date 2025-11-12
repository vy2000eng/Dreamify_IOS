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
            var loginViewController = LoginViewController()
            loginViewController.userIsLoggedInChangeAccountMAnagementOptionsDelegate = self
            self.navigationController?.pushViewController(loginViewController, animated: true)
            
            if(itemTitle == "Log Out"){
                TokenManager.shared.clearTokens()
            }
        }
    }
    

    
    
    
    
    
    
    
    
    
    
}
