//
//  DreamRecordingsViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit

class DreamRecordingsViewController:UIViewController{
    var dreamRecordingsView:DreamRecordsView
    
    
    
    init() {
        
        dreamRecordingsView = DreamRecordsView()
        super.init(nibName: nil, bundle: nil)
    }
  


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupUI()
        setupConstraints()
        super.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Dreams"
        
        // Add subviews
        view.addSubview(dreamRecordingsView.titleLabel)

    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title Label
            dreamRecordingsView.titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dreamRecordingsView.titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            dreamRecordingsView.titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            dreamRecordingsView.titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
        ])
    }
    
}

