//
//  UserInfo.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/16/25.
//

import UIKit

class UserInfoView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "User Information"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textField.textColor = .label
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        //textField.isEditable = false
        textField.isEnabled = false  // This makes it non-editable

        return textField
    }()
    
    private let usernameStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let usernameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textField.textColor = .label
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let createdOnStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let createdOnTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Member Since"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createdOnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subscriptionStatusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subscriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Changes", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    private var originalEmail: String = ""
    private var originalUsername: String = ""
    
    // MARK: - Callbacks
    
    var onResetPasswordTapped: (() -> Void)?
    var onSaveChangesTapped: ((String) -> Void)?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(containerStackView)
        
        // Email stack
        emailStackView.addArrangedSubview(emailTitleLabel)
        emailStackView.addArrangedSubview(emailTextField)
        
        // Username stack
        usernameStackView.addArrangedSubview(usernameTitleLabel)
        usernameStackView.addArrangedSubview(usernameTextField)
        
        // Created on stack
        createdOnStackView.addArrangedSubview(createdOnTitleLabel)
        createdOnStackView.addArrangedSubview(createdOnLabel)
        
        // Subscription status
        subscriptionStatusView.addSubview(subscriptionLabel)
        
        // Add all to container
        containerStackView.addArrangedSubview(emailStackView)
        containerStackView.addArrangedSubview(createSeparator())
        containerStackView.addArrangedSubview(usernameStackView)
        containerStackView.addArrangedSubview(createSeparator())
        containerStackView.addArrangedSubview(createdOnStackView)
        containerStackView.addArrangedSubview(createSeparator())
        containerStackView.addArrangedSubview(subscriptionStatusView)
        containerStackView.addArrangedSubview(saveButton)
        containerStackView.addArrangedSubview(resetPasswordButton)
        
        // Add text field delegates and actions
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // Add button actions
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
        
        setupConstraints()
        
        // Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
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
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Container Stack
            containerStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Text Fields
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Subscription status
            subscriptionStatusView.heightAnchor.constraint(equalToConstant: 50),
            
            subscriptionLabel.centerXAnchor.constraint(equalTo: subscriptionStatusView.centerXAnchor),
            subscriptionLabel.centerYAnchor.constraint(equalTo: subscriptionStatusView.centerYAnchor),
            subscriptionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: subscriptionStatusView.leadingAnchor, constant: 16),
            subscriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: subscriptionStatusView.trailingAnchor, constant: -16),
            
            // Buttons
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange() {
        //let emailChanged = emailTextField.text != originalEmail
       let usernameChanged = usernameTextField.text != originalUsername
        
        saveButton.isHidden = !( usernameChanged)
    }
    
    @objc private func saveButtonTapped() {
        guard let newUserName = usernameTextField.text//, !newEmail.isEmpty,
            //  let newUsername = usernameTextField.text, !newUsername.isEmpty
        else {
            return
        }
        
        onSaveChangesTapped?( newUserName)
        
        // Update original values
        //originalEmail = newEmail
         originalUsername = newUserName
        saveButton.isHidden = true
    }
    
    @objc private func resetPasswordButtonTapped() {
        onResetPasswordTapped?()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Public Methods
    
    func configure(with userInfo: UserInfoResponse) {
        guard let email = userInfo.Email,
               let userName = userInfo.UserName,
               let createdOn = userInfo.createdOn,
                let isSubscribed = userInfo.isSubscribed
        else {
             return
         }
        
        emailTextField.text = email
        usernameTextField.text = userName
        originalEmail = email
        originalUsername = userName
        createdOnLabel.text = formatDate(createdOn)
        
        if isSubscribed{
            subscriptionLabel.text = "✓ Premium Member"
            subscriptionLabel.textColor = .white
            subscriptionStatusView.backgroundColor = .systemGreen
        } else {
            subscriptionLabel.text = "Free Account"
            subscriptionLabel.textColor = .systemGray
            subscriptionStatusView.backgroundColor = .systemGray6
        }
        
        saveButton.isHidden = true
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        inputFormatter.timeZone = TimeZone(identifier: "UTC")
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: dateString) {
            return formatOutput(date: date)
        }
        
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let date = inputFormatter.date(from: dateString) {
            return formatOutput(date: date)
        }
        
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = inputFormatter.date(from: dateString) {
            return formatOutput(date: date)
        }
        
        return dateString
    }

    private func formatOutput(date: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .long
        outputFormatter.timeStyle = .none
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.locale = Locale.current
        return outputFormatter.string(from: date)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
