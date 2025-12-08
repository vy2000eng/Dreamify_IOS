
//  EditDreamView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/22/25.
//

import UIKit

class EditDreamView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        scroll.keyboardDismissMode = .interactive
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tagButton: UIButton = {
        let label = UIButton()
        label.backgroundColor = UIColor.systemGreen
        label.tintColor = .white
        label.layer.cornerRadius = 12
            //label.text =  "+ Add Tag"
        //label.clipsToBounds = true
        label.setTitle("Add tag", for: .normal)


        label.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let dreamTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var addTagButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemGreen
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.setTitle("+ Add Tag", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let dreamTitleTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.backgroundColor = .secondarySystemBackground
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.backgroundColor = .secondarySystemBackground
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Created"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    

    
    // MARK: - Properties
    
    var dream: DreamViewModel
    let dataSource: [(String, UIColor)]

    
    // MARK: - Initialization
    
    init(frame: CGRect, dream: DreamViewModel) {
        self.dream = dream
        self.dataSource = [
            ("Nightmare", UIColor.systemRed),
            ("Lucid", UIColor.systemPurple),
            ("Recurring", UIColor.systemOrange),
            ("Pleasant", UIColor.systemGreen),
            ("Adventure", UIColor.systemBlue),
            ("Anxiety", UIColor.systemYellow)
        ]
//        self.dataSource = [
//            "Nightmare": .systemRed,      // Red for scary/bad
//            "Lucid": .systemPurple,        // Purple for mystical/awareness
//            "Recurring": .systemOrange,    // Orange for repetition/warning
//            "Pleasant": .systemGreen,      // Green for positive/good
//            "Adventure": .systemBlue,      // Blue for exploration/excitement
//            "Anxiety": .systemYellow       // Yellow for caution/stress
//        ]
        super.init(frame: frame)
        setupView()
        configureView()
        setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(dreamTitleLabel)
        contentView.addSubview(dreamTitleTextView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateValueLabel)
        contentView.addSubview(tagButton)
        
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title label
            dreamTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dreamTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dreamTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Title text view
            dreamTitleTextView.topAnchor.constraint(equalTo: dreamTitleLabel.bottomAnchor, constant: 8),
            dreamTitleTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dreamTitleTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dreamTitleTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: dreamTitleTextView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Description text view
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            // Date label
            dateLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Date value
            dateValueLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            dateValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            //dateValueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            
            tagButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 50),
            tagButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tagButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -220),
            tagButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            
        ])
    }
//    let dataSource: [String: UIColor] = [
//        "Nightmare": .systemRed,      // Red for scary/bad
//        "Lucid": .systemPurple,        // Purple for mystical/awareness
//        "Recurring": .systemOrange,    // Orange for repetition/warning
//        "Pleasant": .systemGreen,      // Green for positive/good
//        "Adventure": .systemBlue,      // Blue for exploration/excitement
//        "Anxiety": .systemYellow       // Yellow for caution/stress
//    ]
//    let actionClosure = { [weak self] (action: UIAction) in
//        guard let self  = self else{return}
//        let color = self.dataSource[action.title]
////        {
////            tagButton?.backgroundColor = color
////        }
//    }
    
    private func configureView() {
//        dreamTitleTextView.text = dream.title
//        descriptionTextView.text = dream.transcribedText ?? "No description available"
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .short
//        dateValueLabel.text = dateFormatter.string(from: dream.createdDate)
//        
//        var menuChildren: [UIMenuElement] = []
//        for (tag, color) in dataSource {
//            let action = UIAction(title: tag) { [weak self] action in
//                guard let self = self else { return }
//                if let color = self.dataSource[action.title] {
//                    self.tagButton.backgroundColor = color
//                }
//            }
//            let config = UIImage.SymbolConfiguration(pointSize: 12)
//            action.image = UIImage(systemName: "circle.fill", withConfiguration: config)?
//                .withTintColor(color, renderingMode: .alwaysOriginal)
//            menuChildren.append(action)
//        }
//        tagButton.menu = UIMenu(options: .displayInline, children: menuChildren)
//        tagButton.showsMenuAsPrimaryAction = true
//        tagButton.changesSelectionAsPrimaryAction = true
        dreamTitleTextView.text = dream.title
        descriptionTextView.text = dream.transcribedText ?? "No description available"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateValueLabel.text = dateFormatter.string(from: dream.createdDate)
        
        var menuChildren: [UIMenuElement] = []
        for (tag, color) in dataSource {
            let action = UIAction(title: tag, state: tag == dream.dreamTag ? .on : .off) { [weak self] action in
                guard let self = self else { return }
                self.tagButton.backgroundColor = color
                self.tagButton.setTitle(action.title, for: .normal)
            }
            let config = UIImage.SymbolConfiguration(pointSize: 12)
            action.image = UIImage(systemName: "circle.fill", withConfiguration: config)?
                .withTintColor(color, renderingMode: .alwaysOriginal)
            menuChildren.append(action)
        }
        tagButton.menu = UIMenu(options: .displayInline, children: menuChildren)
        tagButton.showsMenuAsPrimaryAction = true
        tagButton.changesSelectionAsPrimaryAction = true
        
        // Set initial button appearance if tag exists
        if let existingTag = dream.dreamTag {
            if let match = dataSource.first(where: { $0.0 == existingTag }) {
                tagButton.backgroundColor = match.1
                tagButton.setTitle(existingTag, for: .normal)
            }
        }

    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
