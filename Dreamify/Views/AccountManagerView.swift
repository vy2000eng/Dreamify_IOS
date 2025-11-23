//
//  AccountManagerView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/5/25.
//
import UIKit

class AccountManagerView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    // MARK: - Section Views
    private var accountSection: UIView!

    
    
    private lazy var subscriptionSection = createSection(
        title: "Subscription",
        items: [
            SettingsItem(icon: "crown.fill", title: "Manage Subscription", color: .systemOrange),

        ]
    )
    
    private lazy var privacySection = createSection(
        title: "Privacy & Policy",
        items: [
            SettingsItem(icon: "hand.raised.fill", title: "Privacy Policy", color: .systemTeal),
            SettingsItem(icon: "doc.text.fill", title: "Terms of Service", color: .systemTeal),
        ]
    )
    
    // MARK: - Callbacks
    
    var onItemTapped: ((String) -> Void)?
    
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
        
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(titleLabel)
        accountSection = createAccountSection()

        contentStackView.addArrangedSubview(accountSection)
        contentStackView.addArrangedSubview(subscriptionSection)
        contentStackView.addArrangedSubview(privacySection)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content StackView
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    // MARK: - Section Creation
    
    private func createSection(title: String, items: [SettingsItem]) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let sectionLabel = UILabel()
        sectionLabel.text = title
        sectionLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        sectionLabel.textColor = .label
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let cardView = UIView()
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 12
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        let itemsStack = UIStackView()
        itemsStack.axis = .vertical
        itemsStack.translatesAutoresizingMaskIntoConstraints = false
        
        for (index, item) in items.enumerated() {
            let itemView = createItemView(item: item)
            itemsStack.addArrangedSubview(itemView)
            
            if index < items.count - 1 {
                let separator = UIView()
                separator.backgroundColor = .separator
                separator.translatesAutoresizingMaskIntoConstraints = false
                itemsStack.addArrangedSubview(separator)
                separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            }
        }
        
        container.addSubview(sectionLabel)
        container.addSubview(cardView)
        cardView.addSubview(itemsStack)
        
        NSLayoutConstraint.activate([
            sectionLabel.topAnchor.constraint(equalTo: container.topAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            sectionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            cardView.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 12),
            cardView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            itemsStack.topAnchor.constraint(equalTo: cardView.topAnchor),
            itemsStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            itemsStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            itemsStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
        
        return container
    }
    
    private func createItemView(item: SettingsItem) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        let iconBackground = UIView()
        iconBackground.backgroundColor = item.color
        iconBackground.layer.cornerRadius = 8
        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: item.icon)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevronImageView = UIImageView()
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .tertiaryLabel
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        iconBackground.addSubview(iconImageView)
        container.addSubview(iconBackground)
        container.addSubview(titleLabel)
        container.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            iconBackground.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconBackground.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconBackground.widthAnchor.constraint(equalToConstant: 32),
            iconBackground.heightAnchor.constraint(equalToConstant: 32),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconBackground.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            chevronImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 14),
            chevronImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
        container.accessibilityIdentifier = item.title
        
        return container
    }
    
    func changeAccountSection(){
        print("change account section called")
        accountSection.removeFromSuperview()
        accountSection = createAccountSection()
        contentStackView.insertArrangedSubview(accountSection, at: 1)
        UIView.animate(withDuration: 0.75,delay: 0, usingSpringWithDamping: 0.5,initialSpringVelocity: 0.25, options:.transitionCrossDissolve) {
            self.layoutIfNeeded()
        }
        
    }
    
    private func createAccountSection() -> UIView {
        if TokenManager.shared.getAccessToken() == nil {
            return createSection(
                title: "Account Management",
                items: [
                    SettingsItem(icon: "person.circle.fill", title: "Create An Account", color: .systemBlue),
                ]
            )
        } else {
            return createSection(
                title: "Account Management",
                items: [
                    SettingsItem(icon: "person.circle.fill", title: "Manage Account", color: .systemBlue),
                    SettingsItem(icon: "person.circle.fill", title: "Log Out", color: .systemBlue),
                    SettingsItem(icon: "person.circle.fill", title: "Delete All Data", color: .systemBlue),

                ]
            )
        }
    }
    
    @objc private func itemTapped(_ sender: UITapGestureRecognizer) {
        guard let title = sender.view?.accessibilityIdentifier else { return }
        // Add visual feedback
        UIView.animate(withDuration: 0.1, animations: {
            sender.view?.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.view?.alpha = 1.0
            }
        }
        onItemTapped?(title)
    }
}

// MARK: - Supporting Models

struct SettingsItem {
    let icon: String
    let title: String
    let color: UIColor
}
