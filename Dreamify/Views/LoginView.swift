//
//  LoginView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/1/25.
//
import Foundation
import UIKit

class LoginView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    var isSignUpMode = false {
        didSet {
            updateUIForMode()
        }
    }
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var signinSignUpConstraints: [NSLayoutConstraint] = []
    
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
    
//    let fNameTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "First Name"
//        textField.borderStyle = .none
//        textField.backgroundColor = UIColor.systemGray6
//        textField.layer.cornerRadius = 12
//        textField.font = UIFont.systemFont(ofSize: 16)
//        textField.autocapitalizationType = .words
//        textField.autocorrectionType = .no
//        
//        // Add padding
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
//        textField.leftView = paddingView
//        textField.leftViewMode = .always
//        
//        return textField
//    }()
//    
//    let LNameTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Last Name"
//        textField.borderStyle = .none
//        textField.backgroundColor = UIColor.systemGray6
//        textField.layer.cornerRadius = 12
//        textField.font = UIFont.systemFont(ofSize: 16)
//        textField.autocapitalizationType = .words
//        textField.autocorrectionType = .no
//        
//        // Add padding
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
//        textField.leftView = paddingView
//        textField.leftViewMode = .always
//        
//        return textField
//    }()
    
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
//        contentView.addSubview(fNameTextField)
//        contentView.addSubview(LNameTextField)
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
        
        // Initially hide name fields
   
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
            
//            // First Name Text Field
//            fNameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
//            fNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
//            fNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
//            fNameTextField.heightAnchor.constraint(equalToConstant: 50),
//            
//            // Last Name Text Field
//            LNameTextField.topAnchor.constraint(equalTo: fNameTextField.bottomAnchor, constant: 16),
//            LNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
//            LNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
//            LNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
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
        
        setupDynamicConstraints()
    }
    
    private func setupDynamicConstraints() {
        // Remove old constraints
        NSLayoutConstraint.deactivate(signinSignUpConstraints)
        signinSignUpConstraints.removeAll()
        
        if isSignUpMode {
            // Sign Up Mode - Email below Last Name
            signinSignUpConstraints = [
                emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
                emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
                emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
                emailTextField.heightAnchor.constraint(equalToConstant: 50),
                
                passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
                passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
                passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
                passwordTextField.heightAnchor.constraint(equalToConstant: 50)
            ]
        } else {
            // Sign In Mode - Email below Subtitle
            signinSignUpConstraints = [
                emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
                emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
                emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
                emailTextField.heightAnchor.constraint(equalToConstant: 50),
                
                passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
                passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
                passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
                passwordTextField.heightAnchor.constraint(equalToConstant: 50)
            ]
        }
        
        NSLayoutConstraint.activate(signinSignUpConstraints)
    }
    
    private func updateUIForMode() {
        UIView.animate(withDuration: 0.3) {
            if self.isSignUpMode {
                // Switch to Sign Up mode
                self.titleLabel.text = "Create Account"
                self.subtitleLabel.text = "Sign up to get started"
                self.emailTextField.placeholder = "Email"
                self.loginButton.setTitle("Sign Up", for: .normal)
                self.signUpButton.setTitle("Already have an account? Sign In", for: .normal)
             
                self.forgotPasswordButton.isHidden = true
            } else {
                // Switch to Sign In mode
                self.titleLabel.text = "Welcome Back"
                self.subtitleLabel.text = "Sign in to your account"
                self.emailTextField.placeholder = "Email or Username"
                self.loginButton.setTitle("Sign In", for: .normal)
                self.signUpButton.setTitle("Don't have an account? Sign Up", for: .normal)

                self.forgotPasswordButton.isHidden = false
                
                // Clear name fields when switching to sign in

            }
            
            self.setupDynamicConstraints()
            self.layoutIfNeeded()
        }
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
}
