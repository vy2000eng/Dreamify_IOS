//
//  SubscriptionPageView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 12/26/25.
//



import UIKit

class SubscriptionPageView: UIView {
    
    // MARK: - Callbacks
    var onClose: (() -> Void)?
    var onCTA: (() -> Void)?
    var onUpgrade: (() async throws  -> Void)?
    var onRestore: (() -> Void)?
    
    // MARK: - UI Components
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let moonStarsView: UIView = {
        let view = MoonStarsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Unlock Premium Today"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get access to all subscriber benefits"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    
    private let featuresContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground//UIColor(white: 0.96, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let featuresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        let text = "Your subscription auto-renews for $9.99/month until canceled."
        let attributedString = NSMutableAttributedString(string: text)
        let priceRange = (text as NSString).range(of: "$9.99/year")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .semibold), range: priceRange)
        label.attributedText = attributedString
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let upgradeButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Upgrade to Premium", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore purchases", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(.systemGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
   // private var isSubscribed: Bool
    
    
    override init(frame: CGRect) {
       // isSubscribed = TokenManager.shared.getUserSubscribed()
        
        
        super.init(frame: frame)
        
        setupUI()
        setupFeatures()
        setupActions()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        //super.init(coder: coder)
        
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // Always add all subviews
        addSubview(moonStarsView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(featuresContainerView)
        featuresContainerView.addSubview(featuresStackView)
        addSubview(priceLabel)
        addSubview(upgradeButton)
        addSubview(restoreButton)
        addSubview(closeButton)
        print("INIT...")
        // Configure based on subscription status
        if TokenManager.shared.getUserSubscribed() {
            upgradeButton.setTitle("Manage Subscription", for: .normal)
            // upgradeButton.isEnabled = false
           // upgradeButton.backgroundColor = .bl
        } else {
            upgradeButton.setTitle("Upgrade to Premium", for: .normal)
            //upgradeButton.isEnabled = true
           // upgradeButton.backgroundColor = .black
        }
        
        // Set up constraints once
        NSLayoutConstraint.activate([
            // Close button
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Moon and Stars view
            moonStarsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            moonStarsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            moonStarsView.widthAnchor.constraint(equalToConstant: 100),
            moonStarsView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: moonStarsView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Features Container
            featuresContainerView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            featuresContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            featuresContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Features Stack View
            featuresStackView.topAnchor.constraint(equalTo: featuresContainerView.topAnchor, constant: 24),
            featuresStackView.leadingAnchor.constraint(equalTo: featuresContainerView.leadingAnchor, constant: 24),
            featuresStackView.trailingAnchor.constraint(equalTo: featuresContainerView.trailingAnchor, constant: -24),
            featuresStackView.bottomAnchor.constraint(equalTo: featuresContainerView.bottomAnchor, constant: -24),
            
            // Price Label
            priceLabel.bottomAnchor.constraint(equalTo: upgradeButton.topAnchor, constant: -16),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Upgrade Button
            upgradeButton.bottomAnchor.constraint(equalTo: restoreButton.topAnchor, constant: -16),
            upgradeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            upgradeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            upgradeButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Restore Button
            restoreButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            restoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            restoreButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupFeatures() {
        let features = [
            "Unlimited Recordings",
            "Unlimited Analysis",
            "Store Recording in iCloud",
            "Unlimited Transcriptions"
        ]
        
        for feature in features {
            let featureView = createFeatureView(text: feature)
            featuresStackView.addArrangedSubview(featureView)
        }
    }
    
    private func createFeatureView(text: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let checkmarkImageView = UIImageView()
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.tintColor = UIColor(red: 0.4, green: 0.5, blue: 0.9, alpha: 1.0)
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(checkmarkImageView)
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            checkmarkImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
            
            label.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        //ctaButton.addTarget(self, action: #selector(ctaButtonTapped), for: .touchUpInside)
        upgradeButton.addTarget(self, action: #selector(upgradeButtonTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonTapped() {
        onClose?()
    }
    
    //    @objc private func ctaButtonTapped() {
    //        onCTA?()
    //    }
    
    @objc private func upgradeButtonTapped() {
        Task{
            try? await onUpgrade?()
            //onUpgrade?()
            
            
            
        }
    }
    
    @objc private func restoreButtonTapped() {
        onRestore?()
    }
}


import UIKit

class MoonStarsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let moonColor = UIColor(red: 0.2, green: 0.25, blue: 0.4, alpha: 1.0)
        let starColor = UIColor(red: 0.4, green: 0.5, blue: 0.9, alpha: 1.0)
        
        // Draw crescent moon (centered)
        let moonCenter = CGPoint(x: rect.width * 0.42, y: rect.height * 0.5)
        let moonRadius = min(rect.width, rect.height) * 0.3
        
        context.setFillColor(moonColor.cgColor)
        context.addArc(center: moonCenter, radius: moonRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        context.fillPath()
        
        // Cut out part to make crescent
        let cutoutCenter = CGPoint(x: moonCenter.x + moonRadius * 0.5, y: moonCenter.y - moonRadius * 0.15)
        context.setFillColor(UIColor.systemBackground.cgColor)
        context.setBlendMode(.destinationOut)
        context.addArc(center: cutoutCenter, radius: moonRadius * 0.9, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        context.fillPath()
        context.setBlendMode(.normal)
        
        // Draw stars (ONLY on right side)
        let starPositions: [(CGFloat, CGFloat, CGFloat)] = [
            // (x percentage, y percentage, size)
            // Right side cluster only
            (0.70, 0.15, 6),
            (0.85, 0.25, 5),
            (0.78, 0.38, 4),
            (0.90, 0.45, 5),
            (0.82, 0.58, 4),
            (0.72, 0.70, 5),
            (0.88, 0.75, 4),
            (0.95, 0.60, 3)
        ]
        
        for (xPercent, yPercent, size) in starPositions {
            let starX = rect.width * xPercent
            let starY = rect.height * yPercent
            drawStar(at: CGPoint(x: starX, y: starY), size: size, color: starColor, in: context)
        }
    }
    
    private func drawStar(at center: CGPoint, size: CGFloat, color: UIColor, in context: CGContext) {
        context.setFillColor(color.cgColor)
        
        // Draw 4-pointed star
        let points = 4
        let outerRadius = size
        let innerRadius = size * 0.4
        
        var angle: CGFloat = -.pi / 2 // Start at top
        var path = CGMutablePath()
        
        for i in 0..<points * 2 {
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            angle += .pi / CGFloat(points)
        }
        
        path.closeSubpath()
        context.addPath(path)
        context.fillPath()
    }
}
