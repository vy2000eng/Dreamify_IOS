//
//  ResetPasswordViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 12/13/25.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    var resetPasswordView:ResetPasswordView
    
    init(){
        self.resetPasswordView = ResetPasswordView(frame: .zero)//ResetPasswordView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(resetPasswordView)
        resetPasswordView.translatesAutoresizingMaskIntoConstraints = false
        //resetPasswordView.setup
        setupKeyboardObservers()
        
        
        NSLayoutConstraint.activate([
            
            resetPasswordView.topAnchor.constraint(equalTo: view.topAnchor),
            resetPasswordView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resetPasswordView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resetPasswordView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        resetPasswordView.onResetPasswordButtonTapped = { [weak self] resetPasswordDetails in
            guard let self = self else {return}
            sendResetPasswordDetails(resetPasswordDetails: resetPasswordDetails)
            
            
            
            
            
            
            
            
            
            
            
            
        }
        
        
    }
    
    
    private func sendResetPasswordDetails(resetPasswordDetails:ResetPasswordDetailsStruct){
        let requestBody = ["Email":resetPasswordDetails.email, "Code": resetPasswordDetails.code, "NewPassword": resetPasswordDetails.password, "ConfirmPassword": resetPasswordDetails.confirmPassword]
        
        APIClientManager.shared.request(endpoint: "/account/ResetPassword", method: "POST",body:requestBody, type: GenericSuccessFailureResponse.self, completion: {[weak self] result in
            switch result{
            case .success(let response):
                let alert = UIAlertController(title: "Password Reset Successful", message: "You have successfully reset your password.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak self] UIAlertAction in
                    guard let self = self else{return}
                    DispatchQueue.main.async {[weak self] in
                        
                        guard let self = self else { return }
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            let mainViewController = LoginViewController()
                            window.rootViewController = UINavigationController(rootViewController: mainViewController)
                            window.makeKeyAndVisible()
                        }
                        
                    }
                }))
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else{return}
                    present(alert, animated: true)

                    
                }
            case.failure(let error):
                let alert = UIAlertController(title: "Password Reset Failure", message: "The Password reset was unsucessful because \(error)", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak self] UIAlertAction in
                    guard let self = self else{return}
                    DispatchQueue.main.async {[weak self] in
                        
                        guard let self = self else { return }
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            let mainViewController = LoginViewController()
                            window.rootViewController = UINavigationController(rootViewController: mainViewController)
                            window.makeKeyAndVisible()
                        }
                        
                    }
                    
                    
                    
                    
                }))
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else{return}
                    present(alert, animated: true)

                    
                }
                
                
                
                
                
                
                
            }

        })
        
        
        
    }
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
         resetPasswordView.keyboardWillShow(notification: notification)
     }
     
     @objc private func keyboardWillHide(notification: NSNotification) {
         resetPasswordView.keyboardWillHide(notification: notification)
     }
     
     @objc private func dismissKeyboard() {
         view.endEditing(true)
     }
    
    
    
    
    
    
}
