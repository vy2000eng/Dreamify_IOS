//
//  ConfirmEmailCodeView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 12/10/25.
//

import UIKit

class VerificationCodeView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    var onCodeComplete: ((String) -> Void)?
    private var codeFields: [UITextField] = []
    private let numberOfDigits = 6
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Verify Your Email"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the 6-digit code sent to your email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Verify", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let resendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Didn't receive the code? Resend", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    private let activityIndicator: UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView(style: .medium)
//        indicator.color = .white
//        indicator.hidesWhenStopped = true
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        return indicator
//    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(codeStackView)
        addSubview(verifyButton)
        addSubview(resendButton)
      //  verifyButton.addSubview(activityIndicator)
        
        // Create code input fields
        for i in 0..<numberOfDigits {
            let textField = createCodeTextField(tag: i)
            codeFields.append(textField)
            codeStackView.addArrangedSubview(textField)
        }
        
        setupConstraints()
        
        verifyButton.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
        resendButton.addTarget(self, action: #selector(resendButtonTapped), for: .touchUpInside)
        
        // Auto-focus first field
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.codeFields.first?.becomeFirstResponder()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            // Code Stack View
            codeStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            codeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            codeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            codeStackView.heightAnchor.constraint(equalToConstant: 60),
            
            // Verify Button
            verifyButton.topAnchor.constraint(equalTo: codeStackView.bottomAnchor, constant: 40),
            verifyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            verifyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            verifyButton.heightAnchor.constraint(equalToConstant: 50),
            
//            // Activity Indicator
//            activityIndicator.centerXAnchor.constraint(equalTo: verifyButton.centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: verifyButton.centerYAnchor),
            
            // Resend Button
            resendButton.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20),
            resendButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func createCodeTextField(tag: Int) -> UITextField {
        let textField = UITextField()
        textField.tag = tag
        textField.delegate = self
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textField.keyboardType = .numberPad
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Only allow numbers
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        // Only allow single digit
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 1
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // Move to next field if digit entered
        if let text = textField.text, !text.isEmpty {
            if textField.tag < numberOfDigits - 1 {
                codeFields[textField.tag + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        
        updateVerifyButton()
        
        // Auto-verify when all fields filled
        if isCodeComplete() {
            verifyButtonTapped()
        }
    }
    
    // MARK: - Helper Methods
    private func isCodeComplete() -> Bool {
        return codeFields.allSatisfy { !($0.text?.isEmpty ?? true) }
    }
    
    private func updateVerifyButton() {
        let isComplete = isCodeComplete()
        verifyButton.isEnabled = isComplete
        verifyButton.backgroundColor = isComplete ? .systemBlue : .systemGray
    }
    
    private func getCode() -> String {
        return codeFields.compactMap { $0.text }.joined()
    }
    
    func clearCode() {
        codeFields.forEach { $0.text = "" }
        codeFields.first?.becomeFirstResponder()
        updateVerifyButton()
    }
    
//    func setLoading(_ loading: Bool) {
//        verifyButton.isEnabled = !loading
//        verifyButton.setTitle(loading ? "" : "Verify", for: .normal)
//        
//        if loading {
//            activityIndicator.startAnimating()
//        } else {
//            activityIndicator.stopAnimating()
//        }
//    }
    
    // MARK: - Actions
    @objc private func verifyButtonTapped() {
        let code = getCode()
        onCodeComplete?(code)
    }
    
    @objc private func resendButtonTapped() {
        // Implement resend logic
        print("Resend code tapped")
    }
}
