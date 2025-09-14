//
//  LoginViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/1/25.
//

import Foundation
import UIKit
import KeychainAccess
class LoginViewController:UIViewController{
    
    var loginView : LoginView;
    
    init(){
        
        loginView = LoginView(frame: .zero)
        
        
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        setupUI()
        super.viewDidLoad()

 
    }
    func setupUI(){
        loginView.setupUI()
        loginView.setupConstraints()
        setupActions()
        loginView.setupKeyboardObservers()
        view.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false


        
        
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: view.topAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            
        ])

        
    }
    
    
    func setupActions() {
        loginView.showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        // Add text field delegates
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    
    

}

// - MARK: actions
extension LoginViewController{
    
    @objc  func togglePasswordVisibility() {
        loginView.passwordTextField.isSecureTextEntry.toggle()
        loginView.showPasswordButton.isSelected = !loginView.passwordTextField.isSecureTextEntry
    }
    @objc private func forgotPasswordTapped() {
        let alert = UIAlertController(
            title: "Forgot Password",
            message: "Please enter your email address to reset your password",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        
        let resetAction = UIAlertAction(title: "Reset", style: .default) { _ in
            // Handle password reset
            print("Password reset requested")
        }
       // present(resetAction, animated: true)
        //
    }
    @objc private func signUpButtonTapped() {
        // Navigate to sign up screen
        print("Sign up tapped")
    }
    //used in delegate so not private
    @objc func loginButtonTapped() {
        guard validateInput() else { return }
        
        // Show loading state
        setLoadingState(true)
        let email = loginView.emailTextField.text
        let password = loginView.passwordTextField.text
        
        
        APIClientManager.shared.request(
            endpoint: "/account/login",
            method: "POST",
            body: ["email": email, "password": password],
            type: LoginResponse.self) {[weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async{
                switch result {
                case .success(let response):
             
                    TokenManager.shared.saveAccessToken(response.accessToken)
                    TokenManager.shared.saveRefreshToken(response.refreshToken)
                    UserSettings.shared.setLoginState(true)
                    
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                         let window = windowScene.windows.first {
                          let mainViewController = TabsViewController()
                          window.rootViewController = UINavigationController(rootViewController: mainViewController)
                          window.makeKeyAndVisible()
                    }
                    
                    self.setLoadingState(false)

                    

                    
                    print("Success: \(response.accessToken)")
                case .failure(let error):
                    print("Error: \(error)")
                    self.setLoadingState(false)

                }
                
            }
         
        }
        
    }
}
// MARK: utililty functions
extension LoginViewController{
    
    private func handleLoginSuccess() {
        // Handle successful login
        let alert = UIAlertController(
            title: "Success",
            message: "Login successful!",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Navigate to main app or dismiss
            print("Login successful - navigate to main app")
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
  
    
    private func validateInput() -> Bool {
        guard let email = loginView.emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter your email or username")
            return false
        }
        
        guard let password = loginView.passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter your password")
            return false
        }
        
        if password.count < 6 {
            showAlert(message: "Password must be at least 6 characters")
            return false
        }
        
        return true
    }
    
    func setLoadingState(_ isLoading: Bool) {
        loginView.loginButton.isEnabled = !isLoading
        
        if isLoading {
            loginView.loginButton.setTitle("", for: .normal)
            loginView.activityIndicator.startAnimating()
        } else {
            loginView.loginButton.setTitle("Sign In", for: .normal)
            loginView.activityIndicator.stopAnimating()
        }
    }
    
    
    
}
