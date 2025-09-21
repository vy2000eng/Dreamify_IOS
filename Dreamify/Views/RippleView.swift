//
//  RippleView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/17/25.
//

import UIKit

class RippleView: UIView {
    private var rippleLayers: [CAShapeLayer] = []
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    func startAnimating() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] _ in
            self?.createRipple()
        }
    }
    
    func stopAnimating() {
        timer?.invalidate()
        timer = nil
        rippleLayers.forEach { $0.removeFromSuperlayer() }
        rippleLayers.removeAll()
    }
    
    private func createRipple() {
        let rippleLayer = CAShapeLayer()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        rippleLayer.path = UIBezierPath(arcCenter: center, radius: 20, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
        rippleLayer.fillColor = UIColor.clear.cgColor
        rippleLayer.strokeColor = UIColor.systemBlue.withAlphaComponent(0.6).cgColor
        rippleLayer.lineWidth = 3
        
        layer.addSublayer(rippleLayer)
        rippleLayers.append(rippleLayer)
        
        // Animate scale and opacity
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 8.0
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = 2.0
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        
        rippleLayer.add(animationGroup, forKey: "ripple")
        
        // Remove layer after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            rippleLayer.removeFromSuperlayer()
            if let index = self?.rippleLayers.firstIndex(of: rippleLayer) {
                self?.rippleLayers.remove(at: index)
            }
        }
    }
}
