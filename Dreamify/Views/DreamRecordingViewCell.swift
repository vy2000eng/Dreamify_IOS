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
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    lazy var playPauseButton: UIButton = {
        let button                                       = UIButton(type: .system)
        let config                                       = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.backgroundColor                           = .clear
        button.clipsToBounds                             = true
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
        contentView     .addSubview        (mainContentView)
        mainContentView .addSubview        (stackView)
        mainContentView .addSubview        (playPauseButton)
        stackView       .addArrangedSubview(dreamNameLabel)
        
        NSLayoutConstraint.activate([
            
            mainContentView.topAnchor     .constraint(equalTo: contentView    .topAnchor                    ),
            mainContentView.leadingAnchor .constraint(equalTo: contentView    .leadingAnchor , constant: 5  ),
            mainContentView.trailingAnchor.constraint(equalTo: contentView    .trailingAnchor, constant: -5 ),
            mainContentView.bottomAnchor  .constraint(equalTo: contentView    .bottomAnchor                 ),
            stackView      .topAnchor     .constraint(equalTo: mainContentView.topAnchor     , constant: 12 ),
            stackView      .leadingAnchor .constraint(equalTo: mainContentView.leadingAnchor , constant: 12 ),
            stackView      .trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -12),
            stackView      .bottomAnchor  .constraint(equalTo: mainContentView.bottomAnchor  , constant: -12),
            playPauseButton.topAnchor     .constraint(equalTo: mainContentView.topAnchor     , constant: 5  ),
            playPauseButton.leadingAnchor .constraint(equalTo: stackView      .trailingAnchor, constant: -35),
            playPauseButton.bottomAnchor  .constraint(equalTo: mainContentView.bottomAnchor  , constant: -5 ),
        ])
    }

    func configure(with dream: DreamViewModel) {
        mainContentView.frame           = CGRect(x: 0, y: 0, width: 100, height: 100)
        mainContentView.backgroundColor = UIColor.tertiaryLabel//UIColor.secondarySystemBackground
        dreamNameLabel.attributedText   = .create(string: "Lorem ipsum, this is going to have a bunch of text which you will be able to read. This text is going to be of the recoding that you made", font: .systemFont(ofSize: 10,weight: .semibold), color: .tertiaryLabel)

    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        let attribute  = super.preferredLayoutAttributesFitting(layoutAttributes)
//        attribute.size = .init(width: self.parentWidth ?? 0 , height: mainContentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height)
//        return layoutAttributes
//    }
}
