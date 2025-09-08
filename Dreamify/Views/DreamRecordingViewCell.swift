//
//  DreamRecordingViewCell.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//
import UIKit

import SwipeCellKit
class DreamRecordingViewCell: SwipeCollectionViewCell {
    
    lazy var mainContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        return view
    }()
    
    lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var analyzeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemPurple
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.setTitle("Analyze", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var transcriptionAnalysisButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemCyan
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.setTitle("Transcription", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        mainContentView.addSubview(textView)
        mainContentView.addSubview(playPauseButton)
        mainContentView.addSubview(analyzeButton)
        mainContentView.addSubview(transcriptionAnalysisButton)
        
        NSLayoutConstraint.activate([
            // Main content view with padding
            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
        // Analyze button - top right corner
           analyzeButton.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 12),
           analyzeButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -12),
           analyzeButton.widthAnchor.constraint(equalToConstant: 70),
           analyzeButton.heightAnchor.constraint(equalToConstant: 24),
            
            transcriptionAnalysisButton.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 12),
            transcriptionAnalysisButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 12),
            transcriptionAnalysisButton.widthAnchor.constraint(equalToConstant: 70),
            transcriptionAnalysisButton.heightAnchor.constraint(equalToConstant: 24),
            
            
        
            // Text view
            textView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            textView.topAnchor.constraint(equalTo: analyzeButton.bottomAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: playPauseButton.topAnchor, constant: -16),
            
            // Play button - centered at bottom
            playPauseButton.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -16),
            playPauseButton.widthAnchor.constraint(equalToConstant: 40),
            playPauseButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configure(with dream: DreamViewModel) {
        textView.attributedText = .create(
            string: dream.transcribedTest,
            font: .systemFont(ofSize: 16, weight: .regular),
            color: .label
        )
    }
}

//class DreamRecordingViewCell:SwipeCollectionViewCell{
//    
//    lazy var mainContentView: UIView = {
//        let mainContentView                                       = UIView()
//        mainContentView.translatesAutoresizingMaskIntoConstraints = false
//        mainContentView.layer.shadowOffset                        = CGSize(width: 0, height: 1)
//        mainContentView.layer.shadowOpacity                       = 0.2
//        mainContentView.layer.shadowRadius                        = 1.0
//        mainContentView.layer.cornerRadius                        = 2
//        return mainContentView
//    }()
//    
//    lazy var playPauseButton: UIButton = {
//        let button                                       = UIButton(type: .system)
//        button.backgroundColor                           = .clear
//        button.clipsToBounds                             = true
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    lazy var textView:UITextView = {
//        let textView                                       = UITextView()
//        textView.textAlignment                             = .left
//        textView.isEditable                                = false
//        textView.backgroundColor                           =  .clear
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setup() {
//        contentView     .addSubview        (mainContentView)
//        mainContentView .addSubview        (playPauseButton)
//        mainContentView .addSubview        (textView)
//
//        
//        NSLayoutConstraint.activate([
//            
//            mainContentView.topAnchor      .constraint(equalTo: contentView    .topAnchor                    ),
//            mainContentView.leadingAnchor  .constraint(equalTo: contentView    .leadingAnchor , constant: 5  ),
//            mainContentView.trailingAnchor .constraint(equalTo: contentView    .trailingAnchor, constant: -5 ),
//            mainContentView.bottomAnchor   .constraint(equalTo: contentView    .bottomAnchor                 ),
//            
//            playPauseButton.centerXAnchor  .constraint(equalTo: contentView    .centerXAnchor                ),
//            playPauseButton.bottomAnchor   .constraint(equalTo: contentView    .bottomAnchor, constant: -5   ),
//
//            textView.topAnchor             .constraint(equalTo: mainContentView.topAnchor     , constant: 5  ),
//            textView.leadingAnchor         .constraint(equalTo: mainContentView.leadingAnchor , constant: 5  ),
//            textView.trailingAnchor        .constraint(equalTo: mainContentView.trailingAnchor, constant: -5 ),
//            textView.bottomAnchor          .constraint(equalTo: playPauseButton.topAnchor     , constant: -5 ),
//    
//        ])
//    }
//
//    func configure(with dream: DreamViewModel) {
//        mainContentView.frame               = CGRect(x: 0, y: 0, width: 100, height: 100)
//        mainContentView.backgroundColor     = UIColor.tertiaryLabel//UIColor.secondarySystemBackground
//        textView       .attributedText      = .create(string:dream.transcribedTest, font: .systemFont(ofSize: 10,weight: .semibold), color: .tertiaryLabel)// "Lorem ipsum, this is going to have a bunch of text which you will be able to read. This text is going to be of the recoding that you made", font: .systemFont(ofSize: 10,weight: .semibold), color: .tertiaryLabel)
//
//    }
//}
