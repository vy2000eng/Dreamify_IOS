//
//  LoadingViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/10/25.
//

// LoadingOverlayView.swift
import UIKit

class LoadingOverlayView: UIView {
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    init(title: String = "Loading...", subtitle: String? = nil) {
        super.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentContainer)
        contentContainer.addSubview(activityIndicator)
        contentContainer.addSubview(titleLabel)
        contentContainer.addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Content container centered
            contentContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentContainer.widthAnchor.constraint(equalToConstant: 240),
            contentContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 160),
            
            // Activity indicator
            activityIndicator.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 24),
            
            // Title label
            titleLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
            
            // Subtitle label
            subtitleLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Public Methods
    
    func show(in parentView: UIView, animated: Bool = true) {
        parentView.addSubview(self)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentView.topAnchor),
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
        
        activityIndicator.startAnimating()
        
        if animated {
            alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
            }
        }
    }
    
    func hide(animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { _ in
                self.activityIndicator.stopAnimating()
                self.removeFromSuperview()
                completion?()
            }
        } else {
            activityIndicator.stopAnimating()
            removeFromSuperview()
            completion?()
        }
    }
    
    func updateText(title: String, subtitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
