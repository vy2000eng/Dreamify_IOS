//
//  LoginView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/1/25.
//
import Foundation
import UIKit

class LoginView:UIView, UITextFieldDelegate{
    
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
     let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
     let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in to your account"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
     let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email or Username"
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 12
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        // Add padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
     let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 12
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        // Add padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
     let showPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .systemGray2
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 12
        return button
    }()
    
    let orLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    

    
    // MARK: - Setup Methods
    func setupUI() {
        backgroundColor = .systemBackground
        
        // Add subviews
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(showPasswordButton)
        contentView.addSubview(forgotPasswordButton)
        contentView.addSubview(loginButton)
        contentView.addSubview(orLabel)
        contentView.addSubview(signUpButton)
        contentView.addSubview(activityIndicator)
        
        // Configure scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure all views for Auto Layout
        [titleLabel, subtitleLabel, emailTextField, passwordTextField,
         showPasswordButton, forgotPasswordButton, loginButton, orLabel,
         signUpButton, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
     func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Email Text Field
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password Text Field
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Show Password Button
            showPasswordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            showPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -16),
            showPasswordButton.widthAnchor.constraint(equalToConstant: 24),
            showPasswordButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Forgot Password Button
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Login Button
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            
            // Or Label
            orLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 32),
            orLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Sign Up Button
            signUpButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    func setupKeyboardObservers() {
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
        addGestureRecognizer(tapGesture)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
//
//    // MARK: - Actions
//    @objc private func togglePasswordVisibility() {
//        passwordTextField.isSecureTextEntry.toggle()
//        showPasswordButton.isSelected = !passwordTextField.isSecureTextEntry
//    }
//    
//    @objc private func loginButtonTapped() {
//        guard validateInput() else { return }
//        
//        // Show loading state
//        setLoadingState(true)
//        
//        // Simulate login process
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
//            self?.setLoadingState(false)
//            self?.handleLoginSuccess()
//        }
//    }
//    private func handleLoginSuccess() {
//           // Handle successful login
//           let alert = UIAlertController(
//               title: "Success",
//               message: "Login successful!",
//               preferredStyle: .alert
//           )
//           
//           let okAction = UIAlertAction(title: "OK", style: .default) { _ in
//               // Navigate to main app or dismiss
//               print("Login successful - navigate to main app")
//           }
//           
//           alert.addAction(okAction)
//           present(alert, animated: true)
//       }
    
//    @objc private func forgotPasswordTapped() {
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
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        
//        alert.addAction(resetAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true)
//    }
    
//    @objc private func signUpButtonTapped() {
//        // Navigate to sign up screen
//        print("Sign up tapped")
//    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    
//    private func validateInput() -> Bool {
//        guard let email = emailTextField.text, !email.isEmpty else {
//            showAlert(message: "Please enter your email or username")
//            return false
//        }
//        
//        guard let password = passwordTextField.text, !password.isEmpty else {
//            showAlert(message: "Please enter your password")
//            return false
//        }
//        
//        if password.count < 6 {
//            showAlert(message: "Password must be at least 6 characters")
//            return false
//        }
//        
//        return true
//    }
    
    
//    private func showAlert(message: String) {
//           let alert = UIAlertController(
//               title: "Error",
//               message: message,
//               preferredStyle: .alert
//           )
//           
//           let okAction = UIAlertAction(title: "OK", style: .default)
//           alert.addAction(okAction)
//           
//           present(alert, animated: true)
//       }
//       
//       deinit {
//           NotificationCenter.default.removeObserver(self)
//       }
////    
//    private func setLoadingState(_ isLoading: Bool) {
//        loginButton.isEnabled = !isLoading
//        
//        if isLoading {
//            loginButton.setTitle("", for: .normal)
//            activityIndicator.startAnimating()
//        } else {
//            loginButton.setTitle("Sign In", for: .normal)
//            activityIndicator.stopAnimating()
//        }
//    }
//  
    
}
