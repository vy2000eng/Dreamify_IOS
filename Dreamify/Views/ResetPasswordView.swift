//
//  ResetPasswordView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 12/13/25.
//

import Foundation
import UIKit

class ResetPasswordView: UIView, UITextFieldDelegate {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reset Password"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the code sent to your email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
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
    
    let codeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Verification Code"
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 12
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.keyboardType = .numberPad
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        // Add padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    let newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Password"
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
    
    let showNewPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .systemGray2
        return button
    }()
    
    let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
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
    
    let showConfirmPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .systemGray2
        return button
    }()
    
    let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 12
        return button
    }()
    
    let resendCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Resend Code", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    let backToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back to Sign In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    
    var onResetPasswordButtonTapped: ((ResetPasswordDetailsStruct) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - Setup Methods
    func setupUI() {
        backgroundColor = .systemBackground
        
        // Add subviews
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(codeTextField)
        contentView.addSubview(newPasswordTextField)
        contentView.addSubview(showNewPasswordButton)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(showConfirmPasswordButton)
        contentView.addSubview(resetPasswordButton)
        contentView.addSubview(resendCodeButton)
        contentView.addSubview(backToLoginButton)
        contentView.addSubview(activityIndicator)
        
        // Configure scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure all views for Auto Layout
        [titleLabel, subtitleLabel, emailTextField, codeTextField,
         newPasswordTextField, showNewPasswordButton, confirmPasswordTextField,
         showConfirmPasswordButton, resetPasswordButton, resendCodeButton,
         backToLoginButton, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        resetPasswordButton.addTarget(self, action: #selector(handleResetPasswordButtonTapped), for: .touchUpInside)
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
            
            // Email TextField
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Code TextField
            codeTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            codeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            codeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            codeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // New Password TextField
            newPasswordTextField.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 16),
            newPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            newPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Show New Password Button
            showNewPasswordButton.centerYAnchor.constraint(equalTo: newPasswordTextField.centerYAnchor),
            showNewPasswordButton.trailingAnchor.constraint(equalTo: newPasswordTextField.trailingAnchor, constant: -16),
            showNewPasswordButton.widthAnchor.constraint(equalToConstant: 24),
            showNewPasswordButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Confirm Password TextField
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Show Confirm Password Button
            showConfirmPasswordButton.centerYAnchor.constraint(equalTo: confirmPasswordTextField.centerYAnchor),
            showConfirmPasswordButton.trailingAnchor.constraint(equalTo: confirmPasswordTextField.trailingAnchor, constant: -16),
            showConfirmPasswordButton.widthAnchor.constraint(equalToConstant: 24),
            showConfirmPasswordButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Resend Code Button
            resendCodeButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 16),
            resendCodeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Reset Password Button
            resetPasswordButton.topAnchor.constraint(equalTo: resendCodeButton.bottomAnchor, constant: 24),
            resetPasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            resetPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: resetPasswordButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: resetPasswordButton.centerYAnchor),
            
            // Back to Login Button
            backToLoginButton.topAnchor.constraint(equalTo: resetPasswordButton.bottomAnchor, constant: 24),
            backToLoginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backToLoginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
        ])
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc public func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc public func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc private func handleResetPasswordButtonTapped(){
        guard let email = emailTextField.text,
              let code = codeTextField.text,
              let password = newPasswordTextField.text,
              let confirmPassword = confirmPasswordTextField.text
        else { return }
        
        
        
        
        var resetPasswordDetails = ResetPasswordDetailsStruct(email: email, code: code, password: password, confirmPassword: confirmPassword)
        onResetPasswordButtonTapped?(resetPasswordDetails)
        
        
    }
}
