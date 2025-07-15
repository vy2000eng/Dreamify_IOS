//
//  DreamRecordingViewCell.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//
import UIKit

import SwipeCellKit

class DreamRecordingViewCell:SwipeCollectionViewCell{
    private lazy var stackView: UIStackView = {
        let stack                                       = UIStackView()
        stack.axis                                      = .vertical
        stack.spacing                                   = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

     lazy var dreamNameLabel: UILabel = {
        let label       = UILabel()
        return label
    }()


    lazy var createdOnLabel: UILabel = {
        let label       = UILabel()
        return label
    }()
    
    lazy var mainContentView: UIView = {
        let mainContentView                                       = UIView()
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        mainContentView.layer.shadowOffset                        = CGSize(width: 0, height: 1)
        mainContentView.layer.shadowOpacity                       = 0.2
        mainContentView.layer.shadowRadius                        = 1.0
        mainContentView.layer.cornerRadius                        = 2
        return mainContentView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
   

        contentView.addSubview(mainContentView)
        mainContentView.addSubview(stackView)
        
        stackView.addArrangedSubview(dreamNameLabel)
        //stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(createdOnLabel)
        
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with dream: DreamViewModel) {
        mainContentView.backgroundColor = UIColor.secondarySystemBackground
        dreamNameLabel.attributedText   = .create(string: dream.title, font: .systemFont(ofSize: 15,weight: .bold), color: .tertiaryLabel)
        let dateFormatter               = DateFormatter()
        dateFormatter.dateStyle         = .short
        dateFormatter.timeStyle         = .short
        let formattedDate               = dateFormatter.string(from: dream.createdDate)
        createdOnLabel.attributedText   = .create(string: "🕒 \(formattedDate)", font: .systemFont(ofSize: 10,weight: .semibold), color: .secondaryLabel)
    }
    
    
}
