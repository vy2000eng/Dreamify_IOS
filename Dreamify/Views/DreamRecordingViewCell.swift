//
//  DreamRecordingViewCell.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//
import UIKit

import SwipeCellKit
class DreamRecordingViewCell: SwipeCollectionViewCell {
    
    //section cell elements
    lazy var mainSectionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()

    lazy var mainCreatedOnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
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
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //header cell elements
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var sectionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    lazy var createdOnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var scrollViewHeightConstraint: NSLayoutConstraint!
    private var sectionCellConstraints: [NSLayoutConstraint] = []
    private var headerCellConstraints: [NSLayoutConstraint] = []
    private var isHeaderSetup = false



    
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews ()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    private func setupHeaderCell(){

        contentView.addSubview(headerView)
        headerView.addSubview(sectionTitle)
        headerView.addSubview(createdOnLabel)
        

        
        headerCellConstraints = [
            // Header view
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            
            // Section title
            sectionTitle.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            sectionTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            sectionTitle.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            // Created date
            createdOnLabel.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 4),
            createdOnLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            createdOnLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            createdOnLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(headerCellConstraints)

    }
    private func setupSectionCell(){
        // Remove header-only setup
        NSLayoutConstraint.deactivate(headerCellConstraints)
        headerCellConstraints.removeAll()
        
        // Remove header views from contentView (they'll be added to mainContentView)
        headerView.removeFromSuperview()
        sectionTitle.removeFromSuperview()
        createdOnLabel.removeFromSuperview()
        
        // Add main content view
        contentView.addSubview(mainContentView)
        
        // Add header elements to mainContentView instead
        mainContentView.addSubview(sectionTitle)
        mainContentView.addSubview(createdOnLabel)
        mainContentView.addSubview(textView)
        mainContentView.addSubview(playPauseButton)
        mainContentView.addSubview(analyzeButton)
        mainContentView.addSubview(transcriptionAnalysisButton)
        
        // Use sectionCellConstraints instead of headerCellConstraints
        sectionCellConstraints = [
            // Main content view
            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Section title
            sectionTitle.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 16),
            sectionTitle.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            sectionTitle.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            
            // Created date
            createdOnLabel.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 4),
            createdOnLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            createdOnLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            
            // Analyze button
            analyzeButton.topAnchor.constraint(equalTo: createdOnLabel.bottomAnchor, constant: 12),
            analyzeButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            analyzeButton.widthAnchor.constraint(equalToConstant: 70),
            analyzeButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Transcription button
            transcriptionAnalysisButton.topAnchor.constraint(equalTo: createdOnLabel.bottomAnchor, constant: 12),
            transcriptionAnalysisButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            transcriptionAnalysisButton.widthAnchor.constraint(equalToConstant: 100),
            transcriptionAnalysisButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Text view
            textView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            textView.topAnchor.constraint(equalTo: analyzeButton.bottomAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            
            // Play button
            playPauseButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            playPauseButton.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -16),
            playPauseButton.widthAnchor.constraint(equalToConstant: 40),
            playPauseButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(sectionCellConstraints)
    }
    private func resetToHeaderCell() {
        // Deactivate and remove section constraints
        NSLayoutConstraint.deactivate(sectionCellConstraints)
        sectionCellConstraints.removeAll()
        
        // Remove all views
        mainContentView.removeFromSuperview()
        
        // Re-setup header
        setupHeaderCell()
    }
    func configure(with dream: DreamViewModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let formattedDate = dateFormatter.string(from: dream.createdDate)
        
        // Update both sets of labels
        sectionTitle.text = dream.title
        createdOnLabel.text = formattedDate
        mainSectionTitle.text = dream.title
        mainCreatedOnLabel.text = formattedDate
        
        // Toggle visibility
        if dream.retrieveIsOpen() {
            headerView.isHidden = true
            mainContentView.isHidden = false
            NSLayoutConstraint.deactivate(headerCellConstraints)
            NSLayoutConstraint.activate(sectionCellConstraints)

            
            // Update content
            if dream.retrieveIsShowingTextTranscriptionOrAnalysis() {
                transcriptionAnalysisButton.setTitle("Analysis", for: .normal)
                transcriptionAnalysisButton.backgroundColor = .systemOrange
            } else {
                transcriptionAnalysisButton.setTitle("Transcription", for: .normal)
                transcriptionAnalysisButton.backgroundColor = .systemCyan
            }
            
            textView.attributedText = .create(
                string: dream.retrieveIsShowingTextTranscriptionOrAnalysis() ? dream.analyzedText : dream.transcribedText,
                font: .systemFont(ofSize: 16, weight: .regular),
                color: .label
            )
        } else {
            headerView.isHidden = false
            mainContentView.isHidden = true
            NSLayoutConstraint.deactivate(sectionCellConstraints)
            NSLayoutConstraint.activate(headerCellConstraints)

        }
    }
    
    


    private func setupViews() {
        // Add both header and main content views
        contentView.addSubview(headerView)
        contentView.addSubview(mainContentView)
        
        // Header gets its own labels
        headerView.addSubview(sectionTitle)
        headerView.addSubview(createdOnLabel)
        
        // MainContentView gets duplicate labels
        mainContentView.addSubview(mainSectionTitle)
        mainContentView.addSubview(mainCreatedOnLabel)
        mainContentView.addSubview(textView)
        mainContentView.addSubview(playPauseButton)
        mainContentView.addSubview(analyzeButton)
        mainContentView.addSubview(transcriptionAnalysisButton)
        
        // Setup header constraints
        headerCellConstraints = [
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 2),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 2),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 2),
            headerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 2),
            
            sectionTitle.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            sectionTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            sectionTitle.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            createdOnLabel.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 4),
            createdOnLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            createdOnLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            createdOnLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ]
        
        // Setup section constraints
        sectionCellConstraints = [
            // Main content view
            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 2),
            mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 2),
            mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 2),
            mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 2),
            
            // Section title (in mainContentView)
            mainSectionTitle.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 8),
            mainSectionTitle.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            mainSectionTitle.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            
            // Created date (in mainContentView)
            mainCreatedOnLabel.topAnchor.constraint(equalTo: mainSectionTitle.bottomAnchor, constant: 4),
            mainCreatedOnLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            mainCreatedOnLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            
            // Transcription button
            transcriptionAnalysisButton.topAnchor.constraint(equalTo: mainCreatedOnLabel.bottomAnchor, constant: 12),
            transcriptionAnalysisButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            transcriptionAnalysisButton.widthAnchor.constraint(equalToConstant: 100),
            transcriptionAnalysisButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Analyze button
            analyzeButton.topAnchor.constraint(equalTo: mainCreatedOnLabel.bottomAnchor, constant: 12),
            analyzeButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            analyzeButton.widthAnchor.constraint(equalToConstant: 70),
            analyzeButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Text view
            textView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            textView.topAnchor.constraint(equalTo: analyzeButton.bottomAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            
            // Play button
            playPauseButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            playPauseButton.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -16),
            playPauseButton.widthAnchor.constraint(equalToConstant: 40),
            playPauseButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        // Activate all constraints
        NSLayoutConstraint.activate(headerCellConstraints)
        
        // Start with header visible, section hidden
        mainContentView.isHidden = true
        headerView.isHidden = false
    }
}
