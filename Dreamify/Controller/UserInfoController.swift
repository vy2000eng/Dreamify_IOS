//
//  UsreInfoController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/16/25.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    private let userInfoView  : UserInfoView
    private var loadingOverlay: LoadingOverlayView?

    
    init() {
        userInfoView = UserInfoView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func loadView() {
//        view = userInfoView
//    }
    
    override func viewDidLoad() {
        title = "Profile"
        userInfoView.onResetPasswordTapped = { [weak self] in
            self?.showResetPasswordAlert()
        }
        // Handle save changes
        userInfoView.onSaveChangesTapped = { [weak self] newUsername in
            self?.updateUserInfo( username: newUsername)
        }
        setupUI()
        setUpConstraints()
        retrieveUserInfo()

        
        super.viewDidLoad()
      
        
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    private func updateUserInfo(username: String) {
      
        print("update user info submitted")
        showLoading()

        APIClientManager.shared.authRequest(
            endpoint: "/account/UpdateUserInfo",
            method: "POST",
            body: ["newUsername": username, "newPassword":"", "oldPassword": ""],

            type: UserInfoRequest.self,
            completion: { [weak self] result in
            
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                // Hide loading first
                self.hideLoading()
                
                switch result {
                case .success(let response):
                    print("Successfully retrieved details")
                    print(response)
                    
                    //UserSettings.shared.setUserDetails(userDetails: response)
                    //self.userInfoView.configure(with: response)
                    
                case .failure(let error):
                    print("Request failed: \(error)")
                    // TODO: Show error alert
                }
            }
            
            
            
            
            
            
            
            
            
            
        })
        
        
        
        // Create your InfoRequest
//        let request = InfoRequest(
//            newEmail: email,
//            newUserName: username,
//            newPassword: "" // Empty since we're not changing password
//        )
        
        // Call your API
        // networkManager.updateUserInfo(request) { result in
        //     // Handle response
        // }
    }
    
    
    func setupUI(){
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userInfoView)
        
    }
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            
            userInfoView.leadingAnchor.constraint (equalTo: view.leadingAnchor                ),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor               ),
            userInfoView.topAnchor.constraint     (equalTo: view.topAnchor                    ),
            userInfoView.bottomAnchor.constraint  (equalTo: view.bottomAnchor                 ),
            
            
        ])
    }
    
    func retrieveUserInfo(){
        // Show loading BEFORE making the request
        showLoading()
        
        APIClientManager.shared.authRequest(endpoint: "/account/userInfo", method: "GET", type: UserInfoResponse.self) { [weak self] result in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // Hide loading first
                self.hideLoading()
                
                switch result {
                case .success(let response):
                    print("Successfully retrieved details")
                    print(response)
                    
                    UserSettings.shared.setUserDetails(userDetails: response)
                    self.userInfoView.configure(with: response)
                    
                case .failure(let error):
                    print("Request failed: \(error)")
                    // TODO: Show error alert
                }
            }
        }
 

    }
    private func showResetPasswordAlert() {
        let alert = UIAlertController(title: "Reset Password", message: "Enter your old and new password", preferredStyle: .alert)
       
       alert.addTextField { textField in
           textField.placeholder = "Old Password"
           textField.isSecureTextEntry = true
       }
       
       alert.addTextField { textField in
           textField.placeholder = "New Password"
           textField.isSecureTextEntry = true
       }
       
       alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
       alert.addAction(UIAlertAction(title: "Reset", style: .default) { [weak self] _ in
           guard let oldPassword = alert.textFields?[0].text,
                 let newPassword = alert.textFields?[1].text else { return }
           
           self?.resetPassword(oldPassword: oldPassword, newPassword: newPassword)
       })
       
       present(alert, animated: true)
   }
    private func resetPassword(oldPassword: String, newPassword: String) {
        print("reset pwd \(oldPassword) \(newPassword)")
        // Call your API to reset password
        // Use your InfoRequest model with the old and new passwords
    }
}

extension UserInfoViewController {
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
    
}
