//
//  DreamRecordingViewCell.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//



//
//  DreamRecordingViewCell.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/12/25.
//
import UIKit

import SwipeCellKit
class DreamRecordingViewCell: SwipeCollectionViewCell {
    


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
    
    lazy var skipBackwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemBlue
        button.setImage(UIImage(systemName: "gobackward.5"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var skipForwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemBlue
        button.setImage(UIImage(systemName: "goforward.5"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .systemGray5
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        progressView.progress = 0.0
        return progressView
    }()
    
    lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "0:00"
        return label
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "0:00"
        label.textAlignment = .right
        return label
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

    lazy var headerTagLabel: UIButton = {
        let label = UIButton()
        label.backgroundColor = UIColor.systemGreen
        label.tintColor = .white
        label.layer.cornerRadius = 4  // Smaller radius
        label.titleLabel?.font = .systemFont(ofSize: 9, weight: .semibold)  // Smaller font
        label.contentEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)  // Tighter padding
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var tagLabel: UIButton = {
        let label = UIButton()
        label.backgroundColor = UIColor.systemGreen
        label.tintColor = .white
        label.layer.cornerRadius = 4  // Smaller radius
        label.titleLabel?.font = .systemFont(ofSize: 9, weight: .semibold)  // Smaller font
        label.contentEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)  // Tighter padding
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
    //header cell elements
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    

    
    lazy var createdOnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var sectionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.isUserInteractionEnabled = true // Enable interaction
        return label
    }()
    
    lazy var mainSectionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.isUserInteractionEnabled = true // Enable interaction
        return label
    }()
    
    private var scrollViewHeightConstraint: NSLayoutConstraint!
    private var sectionCellConstraints: [NSLayoutConstraint] = []
    private var headerCellConstraints: [NSLayoutConstraint] = []
    private var isHeaderSetup = false
    var onTitleLongPress: ((Int) -> Void)?
    private var cellIndex: Int = 0
    private var dataSource = [
        ("Nightmare", UIColor(red: 0.8, green: 0.1, blue: 0.2, alpha: 1.0)), // Deep crimson
        ("Lucid", UIColor(red: 0.5, green: 0.0, blue: 0.8, alpha: 1.0)), // Electric purple
        ("Recurring", UIColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1.0)), // Bright orange
        ("Pleasant", UIColor(red: 0.2, green: 0.8, blue: 0.5, alpha: 1.0)), // Mint green
        ("Adventure", UIColor(red: 0.0, green: 0.6, blue: 1.0, alpha: 1.0)), // Sky blue
        ("Anxiety", UIColor(red: 0.7, green: 0.5, blue: 0.2, alpha: 1.0)), // Dark mustard


    ]




    
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews ()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGestures() {
        // Add long press gesture to both title labels
        let headerLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleTitleLongPress))
        sectionTitle.addGestureRecognizer(headerLongPress)
        
        let mainLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleTitleLongPress))
        mainSectionTitle.addGestureRecognizer(mainLongPress)
    }
    
    @objc private func handleTitleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // Add haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            onTitleLongPress?(cellIndex)
        }
    }


    
    private func setupHeaderCell(){

        contentView.addSubview(headerView)
        headerView.addSubview(sectionTitle)
        headerView.addSubview(createdOnLabel)
        headerView.addSubview(headerTagLabel)
        

        
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
        mainContentView.addSubview(skipBackwardButton)
        mainContentView.addSubview(playPauseButton)
        mainContentView.addSubview(skipForwardButton)
        mainContentView.addSubview(analyzeButton)
        mainContentView.addSubview(transcriptionAnalysisButton)
        mainContentView.addSubview(tagLabel)
        
        // Use sectionCellConstraints instead of headerCellConstraints
        sectionCellConstraints = [
//            // Main content view
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
    func configure(with dream: DreamViewModel) throws ->Void{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let formattedDate = dateFormatter.string(from: dream.createdDate)
        
        // Update both sets of labels
        sectionTitle.text = dream.title
        createdOnLabel.text = formattedDate
        mainSectionTitle.text = dream.title
        mainCreatedOnLabel.text = formattedDate
        durationLabel.text = try  getAudioDuration(url: getDocumentsDirectory().appendingPathComponent(dream.url))

        
        // Configure tags for both header and main view
        if let dreamTag = dream.dreamTag {
            headerTagLabel.setTitle(dreamTag, for: .normal)
            headerTagLabel.setTitle(dreamTag, for: .normal)
            
            // Find and set color
            for (tag, color) in dataSource {
                if dreamTag == tag {
                    headerTagLabel.backgroundColor = color
                    //tagLabel.backgroundColor = color
                    break
                }
            }
            
            headerTagLabel.isHidden = false
           // tagLabel.isHidden = false
        } else {
            headerTagLabel.isHidden = true
            //tagLabel.isHidden = true
        }
        
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
            if let dreamTag = dream.dreamTag {
                tagLabel.setTitle(dreamTag, for: .normal)
                
                // Find and set color
                for (tag, color) in dataSource {
                    if dreamTag == tag {
                        tagLabel.backgroundColor = color
                        //tagLabel.backgroundColor = color
                        break
                    }
                }
                
                tagLabel.isHidden = false
               // tagLabel.isHidden = false
            } else {
                tagLabel.isHidden = true
                //tagLabel.isHidden = true
            }
            
            
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
        headerView.addSubview(headerTagLabel)

        
        
        // MainContentView gets duplicate labels and progress elements
        mainContentView.addSubview(mainSectionTitle)
        mainContentView.addSubview(mainCreatedOnLabel)
        mainContentView.addSubview(textView)
        mainContentView.addSubview(skipBackwardButton)
        mainContentView.addSubview(playPauseButton)
        mainContentView.addSubview(skipForwardButton)
        mainContentView.addSubview(progressBar)
        mainContentView.addSubview(currentTimeLabel)
        mainContentView.addSubview(durationLabel)
        mainContentView.addSubview(analyzeButton)
        mainContentView.addSubview(transcriptionAnalysisButton)
        mainContentView.addSubview(tagLabel)

        
        // Setup header constraints
        headerCellConstraints = [

            
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 2),
            headerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2),

            sectionTitle.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            sectionTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            sectionTitle.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),

            // Date on the left
            createdOnLabel.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 6),
            createdOnLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),

            // Tag label on the right, same line as date
            headerTagLabel.centerYAnchor.constraint(equalTo: createdOnLabel.centerYAnchor),
            headerTagLabel.leadingAnchor.constraint(equalTo: createdOnLabel.trailingAnchor, constant: 8),
            headerTagLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -16),
            headerTagLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            headerTagLabel.heightAnchor.constraint(equalToConstant: 24),

            createdOnLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)

        ]
        
        // Setup section constraints
        sectionCellConstraints = [
            // Main content view
            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 2),
            mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2),
            
            // Section title (in mainContentView) - MATCHES header
            mainSectionTitle.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 8),
            mainSectionTitle.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            mainSectionTitle.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            
            // Date on the left - MATCHES header (changed from constant: 4 to constant: 6)
            mainCreatedOnLabel.topAnchor.constraint(equalTo: mainSectionTitle.bottomAnchor, constant: 6),
            mainCreatedOnLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            
            // Tag label on the right, same line as date - MATCHES header
            tagLabel.centerYAnchor.constraint(equalTo: mainCreatedOnLabel.centerYAnchor),
            tagLabel.leadingAnchor.constraint(equalTo: mainCreatedOnLabel.trailingAnchor, constant: 8),
            tagLabel.trailingAnchor.constraint(lessThanOrEqualTo: mainContentView.trailingAnchor, constant: -16),
            tagLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            tagLabel.heightAnchor.constraint(equalToConstant: 24),
            
            // Transcription button (below tag/date row)
            transcriptionAnalysisButton.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 12),
            transcriptionAnalysisButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            transcriptionAnalysisButton.widthAnchor.constraint(equalToConstant: 100),
            transcriptionAnalysisButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Analyze button
            analyzeButton.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 12),
            analyzeButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            analyzeButton.widthAnchor.constraint(equalToConstant: 70),
            analyzeButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Text view
            textView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            textView.topAnchor.constraint(equalTo: transcriptionAnalysisButton.bottomAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            
            // Play/pause control buttons (horizontal layout)
            playPauseButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            playPauseButton.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 40),
            playPauseButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Skip backward button (left of play button)
            skipBackwardButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            skipBackwardButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -20),
            skipBackwardButton.widthAnchor.constraint(equalToConstant: 32),
            skipBackwardButton.heightAnchor.constraint(equalToConstant: 32),
            
            // Skip forward button (right of play button)
            skipForwardButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            skipForwardButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 20),
            skipForwardButton.widthAnchor.constraint(equalToConstant: 32),
            skipForwardButton.heightAnchor.constraint(equalToConstant: 32),
            
            // Progress bar (below play button)
            progressBar.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 12),
            progressBar.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            // Time labels (below progress bar)
            currentTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 4),
            currentTimeLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            
            durationLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 4),
            durationLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            durationLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -16)
        ]

        
        // Activate all constraints
        NSLayoutConstraint.activate(headerCellConstraints)
        
        // Start with header visible, section hidden
        mainContentView.isHidden = true
        headerView.isHidden = false
    }
}



//import UIKit
//
//import SwipeCellKit
//class DreamRecordingViewCell: SwipeCollectionViewCell {
//    
//
//
//    lazy var mainCreatedOnLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .systemFont(ofSize: 14, weight: .regular)
//        label.textColor = .secondaryLabel
//        return label
//    }()
//    
//    lazy var mainContentView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.secondarySystemBackground
//        view.layer.cornerRadius = 16
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 2)
//        view.layer.shadowOpacity = 0.1
//        view.layer.shadowRadius = 8
//        return view
//    }()
//    
//    lazy var playPauseButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor.systemBlue
//        button.tintColor = .white
//        button.layer.cornerRadius = 20
//        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    lazy var progressBar: UIProgressView = {
//        let progressView = UIProgressView(progressViewStyle: .default)
//        progressView.translatesAutoresizingMaskIntoConstraints = false
//        progressView.progressTintColor = .systemBlue
//        progressView.trackTintColor = .systemGray5
//        progressView.layer.cornerRadius = 2
//        progressView.clipsToBounds = true
//        progressView.progress = 0.0
//        return progressView
//    }()
//    
//    lazy var currentTimeLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .systemFont(ofSize: 11, weight: .regular)
//        label.textColor = .secondaryLabel
//        label.text = "0:00"
//        return label
//    }()
//    
//    lazy var durationLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .systemFont(ofSize: 11, weight: .regular)
//        label.textColor = .secondaryLabel
//        label.text = "0:00"
//        label.textAlignment = .right
//        return label
//    }()
//    
//    lazy var textView: UITextView = {
//        let textView = UITextView()
//        textView.textAlignment = .left
//        textView.isEditable = false
//        textView.backgroundColor = .clear
//        textView.isScrollEnabled = false
//        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        textView.textContainer.lineFragmentPadding = 0
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }()
//    
//    lazy var analyzeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor.systemPurple
//        button.tintColor = .white
//        button.layer.cornerRadius = 12
//        button.setTitle("Analyze", for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    
//    lazy var transcriptionAnalysisButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor.systemCyan
//        button.tintColor = .white
//        button.layer.cornerRadius = 12
//        button.setTitle("Transcription", for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    lazy var headerTagLabel: UIButton = {
//        let label = UIButton()
//        label.backgroundColor = UIColor.systemGreen
//        label.tintColor = .white
//        label.layer.cornerRadius = 4  // Smaller radius
//        label.titleLabel?.font = .systemFont(ofSize: 9, weight: .semibold)  // Smaller font
//        label.contentEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)  // Tighter padding
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.isUserInteractionEnabled = false
//        return label
//    }()
//    
//    lazy var tagLabel: UIButton = {
//        let label = UIButton()
//        label.backgroundColor = UIColor.systemGreen
//        label.tintColor = .white
//        label.layer.cornerRadius = 4  // Smaller radius
//        label.titleLabel?.font = .systemFont(ofSize: 9, weight: .semibold)  // Smaller font
//        label.contentEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)  // Tighter padding
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.isUserInteractionEnabled = false
//        return label
//    }()
//    //header cell elements
//    
//    lazy var headerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemBackground
//        return view
//    }()
//    
//
//    
//    lazy var createdOnLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .systemFont(ofSize: 14, weight: .regular)
//        label.textColor = .secondaryLabel
//        return label
//    }()
//    
//    lazy var sectionTitle: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .systemFont(ofSize: 18, weight: .semibold)
//        label.textColor = .label
//        label.isUserInteractionEnabled = true // Enable interaction
//        return label
//    }()
//    
//    lazy var mainSectionTitle: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .systemFont(ofSize: 18, weight: .semibold)
//        label.textColor = .label
//        label.isUserInteractionEnabled = true // Enable interaction
//        return label
//    }()
//    
//    private var scrollViewHeightConstraint: NSLayoutConstraint!
//    private var sectionCellConstraints: [NSLayoutConstraint] = []
//    private var headerCellConstraints: [NSLayoutConstraint] = []
//    private var isHeaderSetup = false
//    var onTitleLongPress: ((Int) -> Void)?
//    private var cellIndex: Int = 0
//    private var dataSource = [
//        ("Nightmare", UIColor(red: 0.8, green: 0.1, blue: 0.2, alpha: 1.0)), // Deep crimson
//        ("Lucid", UIColor(red: 0.5, green: 0.0, blue: 0.8, alpha: 1.0)), // Electric purple
//        ("Recurring", UIColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1.0)), // Bright orange
//        ("Pleasant", UIColor(red: 0.2, green: 0.8, blue: 0.5, alpha: 1.0)), // Mint green
//        ("Adventure", UIColor(red: 0.0, green: 0.6, blue: 1.0, alpha: 1.0)), // Sky blue
//        ("Anxiety", UIColor(red: 0.7, green: 0.5, blue: 0.2, alpha: 1.0)), // Dark mustard
//
//
//    ]
//
//
//
//
//    
//    
//    
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews ()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupGestures() {
//        // Add long press gesture to both title labels
//        let headerLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleTitleLongPress))
//        sectionTitle.addGestureRecognizer(headerLongPress)
//        
//        let mainLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleTitleLongPress))
//        mainSectionTitle.addGestureRecognizer(mainLongPress)
//    }
//    
//    @objc private func handleTitleLongPress(_ gesture: UILongPressGestureRecognizer) {
//        if gesture.state == .began {
//            // Add haptic feedback
//            let generator = UIImpactFeedbackGenerator(style: .medium)
//            generator.impactOccurred()
//            
//            onTitleLongPress?(cellIndex)
//        }
//    }
//
//
//    
//    private func setupHeaderCell(){
//
//        contentView.addSubview(headerView)
//        headerView.addSubview(sectionTitle)
//        headerView.addSubview(createdOnLabel)
//        headerView.addSubview(headerTagLabel)
//        
//
//        
//        headerCellConstraints = [
//            // Header view
//            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            headerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//
//            
//            // Section title
//            sectionTitle.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
//            sectionTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//            sectionTitle.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
//            
//            // Created date
//            createdOnLabel.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 4),
//            createdOnLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//            createdOnLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
//            createdOnLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
//        ]
//        
//        NSLayoutConstraint.activate(headerCellConstraints)
//
//    }
//    private func setupSectionCell(){
//        // Remove header-only setup
//        NSLayoutConstraint.deactivate(headerCellConstraints)
//        headerCellConstraints.removeAll()
//        
//        // Remove header views from contentView (they'll be added to mainContentView)
//        headerView.removeFromSuperview()
//        sectionTitle.removeFromSuperview()
//        createdOnLabel.removeFromSuperview()
//        
//        // Add main content view
//        contentView.addSubview(mainContentView)
//        
//        // Add header elements to mainContentView instead
//        mainContentView.addSubview(sectionTitle)
//        mainContentView.addSubview(createdOnLabel)
//        mainContentView.addSubview(textView)
//        mainContentView.addSubview(playPauseButton)
//        mainContentView.addSubview(analyzeButton)
//        mainContentView.addSubview(transcriptionAnalysisButton)
//        mainContentView.addSubview(tagLabel)
//        
//        // Use sectionCellConstraints instead of headerCellConstraints
//        sectionCellConstraints = [
////            // Main content view
//            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//            
//            // Section title
//            sectionTitle.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 16),
//            sectionTitle.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
//            sectionTitle.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
//            
//            // Created date
//            createdOnLabel.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 4),
//            createdOnLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
//            createdOnLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
//            
//            // Analyze button
//            analyzeButton.topAnchor.constraint(equalTo: createdOnLabel.bottomAnchor, constant: 12),
//            analyzeButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
//            analyzeButton.widthAnchor.constraint(equalToConstant: 70),
//            analyzeButton.heightAnchor.constraint(equalToConstant: 24),
//            
//            // Transcription button
//            transcriptionAnalysisButton.topAnchor.constraint(equalTo: createdOnLabel.bottomAnchor, constant: 12),
//            transcriptionAnalysisButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
//            transcriptionAnalysisButton.widthAnchor.constraint(equalToConstant: 100),
//            transcriptionAnalysisButton.heightAnchor.constraint(equalToConstant: 24),
//            
//            // Text view
//            textView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
//            textView.topAnchor.constraint(equalTo: analyzeButton.bottomAnchor, constant: 12),
//            textView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
//            
//            // Play button
//            playPauseButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
//            playPauseButton.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor),
//            playPauseButton.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -16),
//            playPauseButton.widthAnchor.constraint(equalToConstant: 40),
//            playPauseButton.heightAnchor.constraint(equalToConstant: 40)
//
//        ]
//        
//        NSLayoutConstraint.activate(sectionCellConstraints)
//    }
//    private func resetToHeaderCell() {
//        // Deactivate and remove section constraints
//        NSLayoutConstraint.deactivate(sectionCellConstraints)
//        sectionCellConstraints.removeAll()
//        
//        // Remove all views
//        mainContentView.removeFromSuperview()
//        
//        // Re-setup header
//        setupHeaderCell()
//    }
//    func configure(with dream: DreamViewModel) throws -> Void{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .short
//        let formattedDate = dateFormatter.string(from: dream.createdDate)
//        
//        // Update both sets of labels
//        sectionTitle.text = dream.title
//        createdOnLabel.text = formattedDate
//        mainSectionTitle.text = dream.title
//        mainCreatedOnLabel.text = formattedDate
//        durationLabel.text = try  getAudioDuration(url: getDocumentsDirectory().appendingPathComponent(dream.url))
//        
//        // Configure tags for both header and main view
//        if let dreamTag = dream.dreamTag {
//            headerTagLabel.setTitle(dreamTag, for: .normal)
//            headerTagLabel.setTitle(dreamTag, for: .normal)
//            
//            // Find and set color
//            for (tag, color) in dataSource {
//                if dreamTag == tag {
//                    headerTagLabel.backgroundColor = color
//                    //tagLabel.backgroundColor = color
//                    break
//                }
//            }
//            
//            headerTagLabel.isHidden = false
//           // tagLabel.isHidden = false
//        } else {
//            headerTagLabel.isHidden = true
//            //tagLabel.isHidden = true
//        }
//        
//        // Toggle visibility
//        if dream.retrieveIsOpen() {
//            headerView.isHidden = true
//            mainContentView.isHidden = false
//            NSLayoutConstraint.deactivate(headerCellConstraints)
//            NSLayoutConstraint.activate(sectionCellConstraints)
//            
//            // Update content
//            if dream.retrieveIsShowingTextTranscriptionOrAnalysis() {
//                transcriptionAnalysisButton.setTitle("Analysis", for: .normal)
//                transcriptionAnalysisButton.backgroundColor = .systemOrange
//            } else {
//                transcriptionAnalysisButton.setTitle("Transcription", for: .normal)
//                transcriptionAnalysisButton.backgroundColor = .systemCyan
//            }
//            
//            textView.attributedText = .create(
//                string: dream.retrieveIsShowingTextTranscriptionOrAnalysis() ? dream.analyzedText : dream.transcribedText,
//                font: .systemFont(ofSize: 16, weight: .regular),
//                color: .label
//            )
//            if let dreamTag = dream.dreamTag {
//                tagLabel.setTitle(dreamTag, for: .normal)
//                
//                // Find and set color
//                for (tag, color) in dataSource {
//                    if dreamTag == tag {
//                        tagLabel.backgroundColor = color
//                        //tagLabel.backgroundColor = color
//                        break
//                    }
//                }
//                
//                tagLabel.isHidden = false
//               // tagLabel.isHidden = false
//            } else {
//                tagLabel.isHidden = true
//                //tagLabel.isHidden = true
//            }
//            
//            
//        } else {
//            headerView.isHidden = false
//            mainContentView.isHidden = true
//            NSLayoutConstraint.deactivate(sectionCellConstraints)
//            NSLayoutConstraint.activate(headerCellConstraints)
//        }
//    }
//    
//    
//
//
//    private func setupViews() {
//        // Add both header and main content views
//        contentView.addSubview(headerView)
//        contentView.addSubview(mainContentView)
//        
//        // Header gets its own labels
//        headerView.addSubview(sectionTitle)
//        headerView.addSubview(createdOnLabel)
//        headerView.addSubview(headerTagLabel)
//
//        
//        
//        // MainContentView gets duplicate labels and progress elements
//        mainContentView.addSubview(mainSectionTitle)
//        mainContentView.addSubview(mainCreatedOnLabel)
//        mainContentView.addSubview(textView)
//        mainContentView.addSubview(playPauseButton)
//        mainContentView.addSubview(progressBar)
//        mainContentView.addSubview(currentTimeLabel)
//        mainContentView.addSubview(durationLabel)
//        mainContentView.addSubview(analyzeButton)
//        mainContentView.addSubview(transcriptionAnalysisButton)
//        mainContentView.addSubview(tagLabel)
//
//        
//        // Setup header constraints
//        headerCellConstraints = [
//
//            
//            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
//            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
//            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 2),
//            headerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2),
//
//            sectionTitle.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
//            sectionTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//            sectionTitle.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
//
//            // Date on the left
//            createdOnLabel.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 6),
//            createdOnLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//
//            // Tag label on the right, same line as date
//            headerTagLabel.centerYAnchor.constraint(equalTo: createdOnLabel.centerYAnchor),
//            headerTagLabel.leadingAnchor.constraint(equalTo: createdOnLabel.trailingAnchor, constant: 8),
//            headerTagLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -16),
//            headerTagLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
//            headerTagLabel.heightAnchor.constraint(equalToConstant: 24),
//
//            createdOnLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
//
//        ]
//        
//        // Setup section constraints
//        sectionCellConstraints = [
//            // Main content view
//            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
//            mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
//            mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 2),
//            mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2),
//            
//            // Section title (in mainContentView) - MATCHES header
//            mainSectionTitle.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 8),
//            mainSectionTitle.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
//            mainSectionTitle.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
//            
//            // Date on the left - MATCHES header (changed from constant: 4 to constant: 6)
//            mainCreatedOnLabel.topAnchor.constraint(equalTo: mainSectionTitle.bottomAnchor, constant: 6),
//            mainCreatedOnLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
//            
//            // Tag label on the right, same line as date - MATCHES header
//            tagLabel.centerYAnchor.constraint(equalTo: mainCreatedOnLabel.centerYAnchor),
//            tagLabel.leadingAnchor.constraint(equalTo: mainCreatedOnLabel.trailingAnchor, constant: 8),
//            tagLabel.trailingAnchor.constraint(lessThanOrEqualTo: mainContentView.trailingAnchor, constant: -16),
//            tagLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
//            tagLabel.heightAnchor.constraint(equalToConstant: 24),
//            
//            // Transcription button (below tag/date row)
//            transcriptionAnalysisButton.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 12),
//            transcriptionAnalysisButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
//            transcriptionAnalysisButton.widthAnchor.constraint(equalToConstant: 100),
//            transcriptionAnalysisButton.heightAnchor.constraint(equalToConstant: 24),
//            
//            // Analyze button
//            analyzeButton.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 12),
//            analyzeButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
//            analyzeButton.widthAnchor.constraint(equalToConstant: 70),
//            analyzeButton.heightAnchor.constraint(equalToConstant: 24),
//            
//            // Text view
//            textView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
//            textView.topAnchor.constraint(equalTo: transcriptionAnalysisButton.bottomAnchor, constant: 12),
//            textView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
//            
//            // Play button
//            playPauseButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
//            playPauseButton.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor),
//            playPauseButton.widthAnchor.constraint(equalToConstant: 40),
//            playPauseButton.heightAnchor.constraint(equalToConstant: 40),
//            
//            // Progress bar (below play button)
//            progressBar.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 12),
//            progressBar.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
//            progressBar.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
//            progressBar.heightAnchor.constraint(equalToConstant: 4),
//            
//            // Time labels (below progress bar)
//            currentTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 4),
//            currentTimeLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
//            
//            durationLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 4),
//            durationLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
//            durationLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -16)
//        ]
//
//        
//        // Activate all constraints
//        NSLayoutConstraint.activate(headerCellConstraints)
//        
//        // Start with header visible, section hidden
//        mainContentView.isHidden = true
//        headerView.isHidden = false
//    }
//}

