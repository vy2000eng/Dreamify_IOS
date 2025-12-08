//
//  AccountManagerViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/5/25.
//

import UIKit
import GoogleSignIn


class AccountManagerViewController: UIViewController, UserIsLoggedInChangeAccountMAnagementOptions {
    func userIsLoggedInChangeAccountMAnagementOptions() {
        accountManagerView.changeAccountSection()
    }
    
    private let accountManagerViewModel = AccountManangerViewModel()
    private let accountManagerView = AccountManagerView()
    private var loadingOverlay: LoadingOverlayView?

    
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
                    let loginViewController = LoginViewController()
                    loginViewController.userIsLoggedInChangeAccountMAnagementOptionsDelegate = self
                    GIDSignIn.sharedInstance.signOut()
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
                let alert = UIAlertController(title: "Are you sure you want to delete all your data?", message: "This action cannot be undone.", preferredStyle: .alert)

                alert.addAction(
                    UIAlertAction(
                        title: "delete",
                        style: .destructive,
                        handler: { [weak self] UIAlertAction in
                            guard let self = self else { return }
                            showLoading()

                            APIClientManager.shared.authRequest(endpoint: "/account/DeleteUser", method: "POST", type:DeleteUserResponse.self, completion: { [weak self] result in
                                guard let self = self else{return}
                                
                                DispatchQueue.main.async {
                                    self.hideLoading()

                                    switch result{
                                    case .success(let response):
                                        
                                        do{
                                            try self.accountManagerViewModel.deleteAllData()
                                            GIDSignIn.sharedInstance.disconnect { error in
                                                guard error == nil else { return }
                                            }
                                  
                                            self.navigateToLoginView()

                                        }catch let error as NSError{
                                            self.showErrorAlert(message: "Failed to delete local data: \(error.localizedDescription)")
                                        }
                                        
                                    case .failure(let error):
                                        self.showErrorAlert(message: "Failed to delete account: \(error.localizedDescription)")
                                    }
                                }
                                
                        
                            })
                             //self.navigateToLoginView()

                            
                        })
                    )
                
                alert.addAction(UIAlertAction( title: "Cancel", style: .cancel))
                present(alert, animated: true)
                
                
                
                
                

                
                
                
                
                
                
            }
        }
        
    }
    
    private func showErrorAlert(message: String) {
        let errorAlert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(errorAlert, animated: true)
    }
    
    private func showLoading() {
           hideLoading() // Remove any existing overlay
           
           let loading = LoadingOverlayView(
               title: "Analyzing dream...",
               subtitle: "Please wait while we analyze your dream"
           )
           loading.show(in: view)
           loadingOverlay = loading
       }
       
       private func hideLoading() {
           loadingOverlay?.hide()
           loadingOverlay = nil
       }
    
    
    func navigateToLoginView(){
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first {
            let mainViewController = LoginViewController()
            TokenManager.shared.clearTokens()
            accountManagerView.changeAccountSection()
            let loginViewController = LoginViewController()
            loginViewController.userIsLoggedInChangeAccountMAnagementOptionsDelegate = self
            window.rootViewController = UINavigationController(rootViewController: mainViewController)
            window.makeKeyAndVisible()
        }
        
    }
    

    
    
    
    
    
    
    
    
    
    
}
