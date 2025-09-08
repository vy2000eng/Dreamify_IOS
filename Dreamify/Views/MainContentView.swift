//
//  File.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import Foundation
import UIKit

class MainContentView: UIView {
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemRed
        button.layer.cornerRadius = 40
        
        // Clean modern shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 12
        button.layer.shadowOpacity = 0.15
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let waveView: SineWaveView = {
        let view = SineWaveView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(actionButton)
        addSubview(waveView)
        
        NSLayoutConstraint.activate([
            // Action Button - centered
            actionButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 80),
            actionButton.heightAnchor.constraint(equalToConstant: 80),
            
            // Wave View - full width, below button
            waveView.leadingAnchor.constraint(equalTo: leadingAnchor),
            waveView.trailingAnchor.constraint(equalTo: trailingAnchor),
            waveView.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 80),
            waveView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - Recording State Methods
    func startRecording() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.actionButton.backgroundColor = UIColor.systemGray2
            self.actionButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.waveView.alpha = 1
        }
        waveView.startAnimating()
    }
    
    func stopRecording() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.actionButton.backgroundColor = UIColor.systemRed
            self.actionButton.transform = CGAffineTransform.identity
            self.waveView.alpha = 0
        }
        waveView.stopAnimating()
    }
}
