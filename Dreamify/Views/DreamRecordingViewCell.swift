//
//  DreamRecordingViewCell.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//
import UIKit

import SwipeCellKit

class DreamRecordingViewCell:SwipeCollectionViewCell{
    
    lazy var mainContentView: UIView = {
        let mainContentView                                       = UIView()
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        mainContentView.layer.shadowOffset                        = CGSize(width: 0, height: 1)
        mainContentView.layer.shadowOpacity                       = 0.2
        mainContentView.layer.shadowRadius                        = 1.0
        mainContentView.layer.cornerRadius                        = 2
        return mainContentView
    }()
    
    lazy var playPauseButton: UIButton = {
        let button                                       = UIButton(type: .system)
        button.backgroundColor                           = .clear
        button.clipsToBounds                             = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var textView:UITextView = {
        let textView                                       = UITextView()
        textView.textAlignment                             = .left
        textView.isEditable                                = false
        textView.backgroundColor                           =  .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView     .addSubview        (mainContentView)
        mainContentView .addSubview        (playPauseButton)
        mainContentView .addSubview        (textView)

        
        NSLayoutConstraint.activate([
            
            mainContentView.topAnchor      .constraint(equalTo: contentView    .topAnchor                    ),
            mainContentView.leadingAnchor  .constraint(equalTo: contentView    .leadingAnchor , constant: 5  ),
            mainContentView.trailingAnchor .constraint(equalTo: contentView    .trailingAnchor, constant: -5 ),
            mainContentView.bottomAnchor   .constraint(equalTo: contentView    .bottomAnchor                 ),
            
            playPauseButton.centerXAnchor  .constraint(equalTo: contentView    .centerXAnchor                ),
            playPauseButton.bottomAnchor   .constraint(equalTo: contentView    .bottomAnchor, constant: -5   ),

            textView.topAnchor             .constraint(equalTo: mainContentView.topAnchor     , constant: 5  ),
            textView.leadingAnchor         .constraint(equalTo: mainContentView.leadingAnchor , constant: 5  ),
            textView.trailingAnchor        .constraint(equalTo: mainContentView.trailingAnchor, constant: -5 ),
            textView.bottomAnchor          .constraint(equalTo: playPauseButton.topAnchor     , constant: -5 ),
    
        ])
    }

    func configure(with dream: DreamViewModel) {
        mainContentView.frame               = CGRect(x: 0, y: 0, width: 100, height: 100)
        mainContentView.backgroundColor     = UIColor.tertiaryLabel//UIColor.secondarySystemBackground
        textView       .attributedText      = .create(string: "Lorem ipsum, this is going to have a bunch of text which you will be able to read. This text is going to be of the recoding that you made", font: .systemFont(ofSize: 10,weight: .semibold), color: .tertiaryLabel)

    }
}
