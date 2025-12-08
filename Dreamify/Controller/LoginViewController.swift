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
    
    init() {
        loginView = LoginView(frame: .zero)
        //self.userEntityViewModel = nil // Initialize as nil
        // alert = UIAlertController()
        
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
                        
                        guard let userEmail = email else{
                            throw NSError(domain: "LoginViewController", code: 1001, userInfo: [NSLocalizedDescriptionKey : "Email is missing"])
                        }
                        
                        
                        if let foundUser = try self.userEntityViewModel?.getUserByEmail(email: email!) {
                            let user = foundUser
                        } else {
                            let user = try self.userEntityViewModel?.addUser(email: userEmail)
                        }
                        
                        
                        TokenManager.shared.saveAccessToken(response.accessToken)
                        TokenManager.shared.saveRefreshToken(response.refreshToken)
                        TokenManager.shared.saveUserEmail(email: userEmail)
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
                    
                    self.setLoadingState(false)
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
    func btnGoogleSingInDidTap(_ sender: Any) {
        print("View controller: \(self)")
        print("Is view controller in window hierarchy: \(self.view.window != nil)")
       // print("Client ID configured: \(GIDSignIn.sharedInstance.configuration?.clientID ?? "NO CLIENT ID")")
//        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String else {
//            print("ERROR: No client ID found")
//            return
//        }
//        
//        let config = GIDConfiguration(clientID: clientID)
//        
//        GIDSignIn.sharedInstance.configuration = config
        
        print("Starting sign in...")
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: self,
            hint: nil,
            additionalScopes: []
        ) { signInResult, error in
            
            guard error == nil else {
                print("Sign in error: \(error!)")
                return
            }
            guard let signInResult = signInResult else { return }
            
            // Get the ID token to send to your backend
            guard let idToken = signInResult.user.idToken?.tokenString else {
                print("No ID token")
                return
            }
            
            // Get user info
            let email = signInResult.user.profile?.email
            let name = signInResult.user.profile?.name
            
            print("Google ID Token: \(idToken)")
            print("Email: \(email ?? "none")")
            print("Name: \(name ?? "none")")
            
            // Send to your .NET backend
            self.authenticateWithBackend(googleIdToken: idToken, email: email, name: name)

        }
    }
    
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
        loginView.isSignUpMode.toggle()
        print(loginView.isSignUpMode ? "Sign up mode" : "Sign in mode")
    }
    //used in delegate so not private
    @objc func loginButtonTapped() {
        print("login tapped")
        guard validateInput() else { return }
        
        // Show loading state
        setLoadingState(true)
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
                        
                        
                 
                        
                        self.setLoadingState(false)
                        print("Success: \(response.accessToken)")
                    case .failure(let error):
                        //TODO: add an actual error lol
                        print("Error: \(error)")
                        self.setLoadingState(false)
                
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                            self.present(alert,animated: true)

                        
                    }
                    
                }
             
            }
            
        }else{
//            let fname = loginView.fNameTextField.text;
//            let lname = loginView.LNameTextField.text;
        
            
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

                            UserSettings.shared.setLoginState(true)
                            //navigationController?.
                            
                            
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                 let window = windowScene.windows.first {
                                  let mainViewController = TabsViewController()
                                  window.rootViewController = UINavigationController(rootViewController: mainViewController)
                                  window.makeKeyAndVisible()
                            }
                            
                            self.setLoadingState(false)
                            print("Success: \(response.accessToken)")
                            
                        }catch let error as NSError{
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                            self.present(alert,animated: true)
                            
                        }
                   
                    case .failure(let error):
                        //TODO: add an actual error lol
                        print("Error: \(error)")
                        self.setLoadingState(false)
                        let alert = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                        self.present(alert,animated: true)
                        //self.createAlert(title: "registration Error", msg: error.localizedDescription)
                       // self.present(UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .alert),animated: true)
                     
                        //alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                        //self.present(alert, animated: true)
                        
                    }
                    
                }
             
            }
        }
        userIsLoggedInChangeAccountMAnagementOptionsDelegate?.userIsLoggedInChangeAccountMAnagementOptions()

        
    }
}
// MARK: utililty functions
extension LoginViewController{
//    private func createAlert(title:String, msg:String){
//        alert.title = title
//        alert.message = msg
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        
//        
//        
////        let alert = UIAlertController(title: title,
////                                      message: msg,
////                                      preferredStyle: .alert)
//    }
    
    
    
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
