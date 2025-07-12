//
//  File.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import Foundation
import UIKit

class MainContentView:UIView{
     let titleLabel: UILabel = {
           let label = UILabel()
           label.text = "Welcome Home"
           label.font = UIFont.boldSystemFont(ofSize: 24)
           label.textAlignment = .center
           label.textColor = .systemBlue
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
        let descriptionLabel: UILabel = {
           let label = UILabel()
           label.text = "This is your home screen"
           label.font = UIFont.systemFont(ofSize: 16)
           label.textAlignment = .center
           label.textColor = .systemGray
           label.numberOfLines = 0
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
        let actionButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Tap To Record", for: .normal)
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
           button.backgroundColor = .systemRed
           button.setTitleColor(.white, for: .normal)
           button.clipsToBounds = true
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
    
    
    override init(frame: CGRect) {
        
        super.init(frame:   frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


