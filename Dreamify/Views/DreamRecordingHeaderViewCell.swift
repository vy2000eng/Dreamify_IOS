//
//  File.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/23/25.
//

import Foundation
import UIKit
import SwipeCellKit

class DreamRecordingHeaderViewCell: SwipeCollectionViewCell {
    
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(headerView)
        headerView.addSubview(sectionTitle)
        headerView.addSubview(createdOnLabel)
        
        NSLayoutConstraint.activate([
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
        ])
    }
    
    func configureDreamRecordingViewHeader(viewmodel: DreamRecordingViewModel, row: Int) {
        let sectionTitleText = viewmodel.dream(by: row).title
        let createdDate = viewmodel.dream(by: row).createdDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let formattedCreatedDate = dateFormatter.string(from: createdDate)
        
        sectionTitle.text = sectionTitleText
        createdOnLabel.text = formattedCreatedDate
    }
}

