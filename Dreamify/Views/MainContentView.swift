//
//  File.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//


import UIKit

class MainContentView: UIView {
    
    // MARK: - UI Elements
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemRed
        button.layer.cornerRadius = 50
        
        // Better shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowRadius = 16
        button.layer.shadowOpacity = 0.2
        
        // Add icon
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        button.setImage(UIImage(systemName: "mic.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Choose one of these visual effects:
    let pulseView: PulseView = {
        let view = PulseView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    let audioVisualizerView: AudioVisualizerView = {
        let view = AudioVisualizerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    let rippleView: RippleView = {
        let view = RippleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private var isRecording = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(actionButton)
       // addSubview(pulseView)
         addSubview(audioVisualizerView) // Alternative
        // addSubview(rippleView) // Alternative
        
        NSLayoutConstraint.activate([
            // Action Button - larger and centered
            actionButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 100),
            actionButton.heightAnchor.constraint(equalToConstant: 100),
            
             //Pulse view - same size as button
//            pulseView.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor),
//            pulseView.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor),
//            pulseView.widthAnchor.constraint(equalToConstant: 200),
//            pulseView.heightAnchor.constraint(equalToConstant: 200),
            
            // Audio visualizer - below button
            audioVisualizerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            audioVisualizerView.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 80),
            audioVisualizerView.widthAnchor.constraint(equalToConstant: 300),
            audioVisualizerView.heightAnchor.constraint(equalToConstant: 60),
            
//           //  Ripple view - behind button
//            rippleView.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor),
//            rippleView.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor),
//            rippleView.widthAnchor.constraint(equalToConstant: 300),
//            rippleView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Send visual effects behind the button
       //// sendSubviewToBack(pulseView)
        sendSubviewToBack(audioVisualizerView)
       // sendSubviewToBack(rippleView)
    }
    
    // MARK: - Recording State Methods
    func startRecording() {
        isRecording = true
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8) {
            self.actionButton.backgroundColor = UIColor.systemGray2
            self.actionButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.audioVisualizerView.alpha = 1
        }
        
        // Change icon to stop
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        actionButton.setImage(UIImage(systemName: "stop.fill", withConfiguration: config), for: .normal)
        
        //pulseView.startAnimating()
        audioVisualizerView.startAnimating()
    }
    
    func stopRecording() {
        isRecording = false
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.actionButton.backgroundColor = UIColor.systemRed
            self.actionButton.transform = CGAffineTransform.identity
            self.audioVisualizerView.alpha = 0
        }
        
        // Change icon back to mic
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        actionButton.setImage(UIImage(systemName: "mic.fill", withConfiguration: config), for: .normal)
        
        //pulseView.stopAnimating()
        audioVisualizerView.stopAnimating()
    }
}

// MARK: - Option 1: Pulse Effect
class PulseView: UIView {
    private var pulseLayer1: CAShapeLayer!
    private var pulseLayer2: CAShapeLayer!
    private var pulseLayer3: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPulseLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPulseLayers()
    }
    
    private func setupPulseLayers() {
        backgroundColor = .clear
        
        pulseLayer1 = createPulseLayer(color: UIColor.systemRed.withAlphaComponent(0.4))
        pulseLayer2 = createPulseLayer(color: UIColor.systemOrange.withAlphaComponent(0.3))
        pulseLayer3 = createPulseLayer(color: UIColor.systemYellow.withAlphaComponent(0.2))
        
        layer.addSublayer(pulseLayer1)
        layer.addSublayer(pulseLayer2)
        layer.addSublayer(pulseLayer3)
    }
    
    private func createPulseLayer(color: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = color.cgColor
        layer.opacity = 0
        return layer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        
        [pulseLayer1, pulseLayer2, pulseLayer3].forEach { layer in
            layer?.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
        }
    }
    
    func startAnimating() {
        animatePulse(layer: pulseLayer1, delay: 0.0)
        animatePulse(layer: pulseLayer2, delay: 0.3)
        animatePulse(layer: pulseLayer3, delay: 0.6)
    }
    
    func stopAnimating() {
        [pulseLayer1, pulseLayer2, pulseLayer3].forEach { $0?.removeAllAnimations() }
    }
    
    private func animatePulse(layer: CAShapeLayer, delay: TimeInterval) {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.3
        scaleAnimation.toValue = 1.0
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.8
        opacityAnimation.toValue = 0.0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = 1.5
        animationGroup.repeatCount = .infinity
        animationGroup.beginTime = CACurrentMediaTime() + delay
        
        layer.add(animationGroup, forKey: "pulse")
    }
}
