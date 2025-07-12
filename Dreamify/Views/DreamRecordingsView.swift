//
//  DreamRecordings.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//


import Foundation
import UIKit



class DreamRecordsView:UIView{
    let titleLabel: UILabel = {
          let label = UILabel()
          label.text = "Welcome Home"
          label.font = UIFont.boldSystemFont(ofSize: 24)
          label.textAlignment = .center
          label.textColor = .systemBlue
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
    
    
    override init(frame: CGRect) {
        super.init(frame:   frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
