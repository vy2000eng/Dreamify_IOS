//
//  LoginViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/1/25.
//

import Foundation
import UIKit
import KeychainAccess
import GoogleSignIn
class LoginViewController:UIViewController{
    
    var loginView : LoginView;
    //var alert :UIAlertController;
    var userEntityViewModel:UserEntityViewModel?
    weak var userIsLoggedInChangeAccountMAnagementOptionsDelegate:UserIsLoggedInChangeAccountMAnagementOptions?
    private var loadingOverlay: LoadingOverlayView?

    init() {
        loginView = LoginView(frame: .zero)

        
        super.init(nibName: nil, bundle: nil)
        
        do {
            self.userEntityViewModel = try UserEntityViewModel(email: nil)
            
        } catch let err as NSError {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let alert = UIAlertController(title: "Initialization Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
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
        //TODO: need to add this back WARNING inteferes with Google Auth Screen
        // loginView.setupKeyboardObservers()
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
        loginView.googleSignInButton.addTarget(self, action: #selector(btnGoogleSingInDidTap), for: .touchUpInside)
        
        // Add text field delegates
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    func authenticateWithBackend(googleIdToken: String, email: String?, name: String?) {
        APIClientManager.shared.request(endpoint: "/account/SignInWithGoogle",method: "POST",body: ["IdToken":googleIdToken],type: LoginResponse.self){ [weak self ] result in
            guard let self = self else{return}
            DispatchQueue.main.async{
                switch result{
                case . success(let response):
                    UserSettings.shared.setLoginState(true)
                    do{
                        print("THIS INDICATED IF FIRST LOGIN OR NOT: \(response.isFirstLogin)")
                        guard let userEmail = email else{
                            throw NSError(domain: "LoginViewController", code: 1001, userInfo: [NSLocalizedDescriptionKey : "Email is missing"])
                        }
                        
                        
                        if let foundUser = try self.userEntityViewModel?.getUserByEmail(email: email!) {
                            let user = foundUser
                        } else {
                             try self.userEntityViewModel?.addUser(email: userEmail)
                        }
                        
                        
                        TokenManager.shared.saveAccessToken(response.accessToken)
                        TokenManager.shared.saveRefreshToken(response.refreshToken)
                        TokenManager.shared.saveUserEmail(email: userEmail)
                        if(response.isFirstLogin){
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first {
                                let mainViewController = EmailVerififcationController()
                                window.rootViewController = UINavigationController(rootViewController: mainViewController)
                                window.makeKeyAndVisible()
                            }
                            
                        }else{
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first {
                                let mainViewController = TabsViewController()
                                window.rootViewController = UINavigationController(rootViewController: mainViewController)
                                window.makeKeyAndVisible()
                            }
                            
                        }
                       
                        
                    }catch let err as NSError{
                        let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                        
                        self.present(alert, animated: true)
                        
                        print("\(err.localizedDescription)")
                        
                    }
                    
                   // self.setLoadingState(false)
                    print("Success: \(response.accessToken)")
                    
                    
                case.failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.present(alert,animated: true)
                }
                
            }
        }
        
    }
}
    
    
    



// - MARK: actions
extension LoginViewController{
    @objc
    func btnGoogleSingInDidTap(_ sender: Any) throws -> Void {


        
        print("Starting sign in...")
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: self,
            hint: nil,
            additionalScopes: []
        ) { signInResult, error in
            do{
                self.showLoading()
                
                guard error == nil else {
                    //TODO: add error in here later
                    throw NSError(domain: "LoginViewController", code: 1, userInfo: [NSLocalizedDescriptionKey : "An Unexpected Error Occured While Trying to Log in With Google"])

                    //return
                }
                guard let signInResult = signInResult else {
                    throw NSError(domain: "LoginViewController", code: 1, userInfo: [NSLocalizedDescriptionKey : "An Unexpected Error Occured While Signing in With Google"])

                }
                
                // Get the ID token to send to your backend
                guard let idToken = signInResult.user.idToken?.tokenString else {
                    //TODO: add an actual error here
                 
                    throw NSError(domain: "LoginViewController", code: 1, userInfo: [NSLocalizedDescriptionKey : "An Unexpected Error Occured While Signing in With Google"])

                }
                
                // Get user info
                let email = signInResult.user.profile?.email
                let name = signInResult.user.profile?.name
                self.hideLoading()

                self.authenticateWithBackend(googleIdToken: idToken, email: email, name: name)
                
                
//                let vc = EmailVerififcationController()
//                
//                self.navigationController?.pushViewController(vc, animated: true)
                
            }catch let err as NSError{
                self.hideLoading()
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                
                self.present(alert, animated: true)
                
                
            }
    

        }
    }
    
    @objc  func togglePasswordVisibility() {
        loginView.passwordTextField.isSecureTextEntry.toggle()
        loginView.showPasswordButton.isSelected = !loginView.passwordTextField.isSecureTextEntry
    }
    @objc private func forgotPasswordTapped() {
        print("forgot password button tapped")
        DispatchQueue.main.async{[weak self] in
            guard let self = self else{return}
            let vc = SendPasswordResetEmailViewController()

            navigationController?.pushViewController(vc, animated: true)
            
        }
//        let alert = UIAlertController(
//            title: "Forgot Password",
//            message: "Please enter your email address to reset your password",
//            preferredStyle: .alert
//        )
//        
//        alert.addTextField { textField in
//            textField.placeholder = "Email"
//            textField.keyboardType = .emailAddress
//        }
//        
//        let resetAction = UIAlertAction(title: "Reset", style: .default) { _ in
//            // Handle password reset
//            print("Password reset requested")
//        }

    }
    @objc private func signUpButtonTapped() {
        // Navigate to sign up screen
        print("Sign up tapped")
        loginView.isSignUpMode.toggle()
        print(loginView.isSignUpMode ? "Sign up mode" : "Sign in mode")
    }
    //used in delegate so not private
    @objc func loginButtonTapped() {
        print("login tapped")
        guard validateInput() else { return }
        
        // Show loading state
        //setLoadingState(true)
        showLoading()
        let email = loginView.emailTextField.text
        let password = loginView.passwordTextField.text
        
    
        
        if(!loginView.isSignUpMode){
            APIClientManager.shared.request(
                endpoint: "/account/login",
                method: "POST",
                body: ["email": email, "password": password],
                type: LoginResponse.self) {[weak self] result in
                guard let self = self else {return}
                DispatchQueue.main.async{
                    switch result {
                    case .success(let response):
                        
         
                        UserSettings.shared.setLoginState(true)
                        do{
                            let user = try  self.userEntityViewModel?.getUserByEmail(email: email!)
                            
                           TokenManager.shared.saveAccessToken(response.accessToken)
                           TokenManager.shared.saveRefreshToken(response.refreshToken)
                            TokenManager.shared.saveUserEmail(email: user!.userEmail)
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                 let window = windowScene.windows.first {
                                  let mainViewController = TabsViewController()
                                  window.rootViewController = UINavigationController(rootViewController: mainViewController)
                                  window.makeKeyAndVisible()
                            }
                            
                            
                        }catch let err as NSError{
                            let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                            self.present(alert, animated: true)
                            print("\(err.localizedDescription)")
                            
                        }
                        
                        //self.setLoadingState(false)
                        self.hideLoading()
                        
                        print("Success: \(response.accessToken)")
                    case .failure(let error):
                        //TODO: add an actual error lol
                        print("Error: \(error)")
                       // self.setLoadingState(false)
                        self.hideLoading()
                
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                        self.present(alert,animated: true)

                        
                    }
                    
                }
             
            }
            
        }else{
            APIClientManager.shared.request(
                endpoint: "/account/register",
                method: "POST",
                body: ["email": email, "password": password],
                type: LoginResponse.self) {[weak self] result in
                guard let self = self else {return}
                DispatchQueue.main.async{
                    switch result {
                    case .success(let response):
                        do {
                            let user  = try self.userEntityViewModel?.addUser(email: email!)
                     
                            TokenManager.shared.saveAccessToken(response.accessToken)
                            TokenManager.shared.saveRefreshToken(response.refreshToken)
                            TokenManager.shared.saveUserEmail(email: user!.userEmail)

                            //UserSettings.shared.setLoginState(true)
                            
                            
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                 let window = windowScene.windows.first {
                                  let mainViewController = EmailVerififcationController()
                                  window.rootViewController = UINavigationController(rootViewController: mainViewController)
                                  window.makeKeyAndVisible()
                            }
                            
                            //self.setLoadingState(false)
                            self.hideLoading()
                            print("Success: \(response.accessToken)")
                            
                        }catch let error as NSError{
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                            self.present(alert,animated: true)
                            
                        }
                   
                    case .failure(let error):
                        //TODO: add an actual error lol
                        print("Error: \(error)")
                        //self.setLoadingState(false)
                        self.hideLoading()
                        let alert = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                        self.present(alert,animated: true)

                        
                    }
                    
                }
             
            }
        }
        userIsLoggedInChangeAccountMAnagementOptionsDelegate?.userIsLoggedInChangeAccountMAnagementOptions()

        
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
    private func showLoading() {
           hideLoading() // Remove any existing overlay
           
           let loading = LoadingOverlayView(
               title: "Logging You In...",
               subtitle: "Please wait while we analyze your dream"
           )
           loading.show(in: view)
           loadingOverlay = loading
       }
       
    private func hideLoading() {
       loadingOverlay?.hide()
       loadingOverlay = nil
    }
    
//    func setLoadingState(_ isLoading: Bool) {
//        loginView.loginButton.isEnabled = !isLoading
//        
//        if isLoading {
//            loginView.loginButton.setTitle("", for: .normal)
//            loginView.activityIndicator.startAnimating()
//        } else {
//            loginView.loginButton.setTitle("Sign In", for: .normal)
//            loginView.activityIndicator.stopAnimating()
//        }
//    }
    
    
    
}
