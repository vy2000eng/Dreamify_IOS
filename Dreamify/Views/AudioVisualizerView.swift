//
//  AudioVisualizerView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/17/25.
//
import UIKit
class AudioVisualizerView: UIView {
    private var barViews: [UIView] = []
    private let numberOfBars = 20
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       setupBars()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBars()
    }

    
    private func setupBars() {
        backgroundColor = .clear
        
        let barWidth: CGFloat = 6
        let spacing: CGFloat = 8
        let totalWidth = CGFloat(numberOfBars) * barWidth + CGFloat(numberOfBars - 1) * spacing
        let startX = (300 - totalWidth) / 2  // Changed from 200 to 300
        
        for i in 0..<numberOfBars {
            let barView = UIView()
            barView.backgroundColor = UIColor.label.withAlphaComponent(0.8)
            barView.layer.cornerRadius = 3
            
            let x = startX + CGFloat(i) * (barWidth + spacing)
            barView.frame = CGRect(x: x, y: 40, width: barWidth, height: 12)
            
            addSubview(barView)
            barViews.append(barView)
        }
    }
    
    func startAnimating() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] _ in
            self?.animateBars()
        }
    }
    
    func stopAnimating() {
        timer?.invalidate()
        timer = nil
        
        for barView in barViews {
            UIView.animate(withDuration: 0.5) {
                barView.frame.size.height = 8
                barView.frame.origin.y = 40
            }
        }
    }
    
    private func animateBars() {
        for barView in barViews {
            let newHeight = CGFloat.random(in: 8...55)
            let newY = 48 - newHeight
            
            UIView.animate(withDuration: 0.15) {
                barView.frame.size.height = newHeight
                barView.frame.origin.y = newY
            }
        }
    }
}
