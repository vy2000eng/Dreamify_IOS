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
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

     lazy var dreamNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        return label
    }()

//     lazy var countLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = .secondaryLabel
//        return label
//    }()

    lazy var createdOnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var mainContentView: UIView = {
        let mainContentView = UIView()
        mainContentView.translatesAutoresizingMaskIntoConstraints = false

        mainContentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        mainContentView.layer.shadowOpacity = 0.2
        mainContentView.layer.shadowRadius = 1.0
        mainContentView.layer.borderWidth = 2
        mainContentView.layer.cornerRadius = 2
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
//        mainContentView.layer.borderColor = ColorManager.shared.currentTheme.backGroundColor == .black
//        ?  UIColor.white.withAlphaComponent(0.1).cgColor
//        :  UIColor.black.withAlphaComponent(0.1).cgColor
        
        mainContentView.backgroundColor = .systemBackground//topic.backGroundColor
        
        dreamNameLabel.attributedText = .create(string: dream.title, font: .systemFont(ofSize: 15), color: .systemTeal)
        //countLabel.attributedText = .create(string: "📄 \(dream.topicCount) flashcards", font: topic.subtitleFont, color: topic.fontColorSecondary)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let formattedDate = dateFormatter.string(from: dream.createdDate)
        createdOnLabel.attributedText = .create(string: "🕒 \(formattedDate)", font: .systemFont(ofSize: 10), color: .systemMint)
    }
    
    
}
