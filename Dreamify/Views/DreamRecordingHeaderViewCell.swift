//
//  File.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/23/25.
//

import Foundation
import UIKit
import SwipeCellKit

class DreamRecordingHeaderViewCell:SwipeCollectionViewCell{
    lazy var headerView: UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        
        return v
    }()
    lazy var sectionTitle: UILabel = {
       let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var createdOnLabel: UILabel = {
        let label       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension DreamRecordingHeaderViewCell{
    private func setup(){
        contentView.addSubview(headerView)
        headerView.addSubview(sectionTitle)
        headerView.addSubview(createdOnLabel)
        setupMainConstraints()
    }
    
    private func setupMainConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        setupConstraints()
    }
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            sectionTitle.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            sectionTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant:10),
            createdOnLabel.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 5),
            createdOnLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
        ])
    }
    func configureDreamRecordingViewHeader(viewmodel: DreamRecordingViewModel, row: Int){
        headerView.backgroundColor      = UIColor.secondarySystemBackground
        let sectionTitleText            = viewmodel.dream(by: row).title
        let createdDate                 = viewmodel.dream(by: row).createdDate
        let dateFormatter               =  DateFormatter()
        dateFormatter.dateStyle         = .short
        dateFormatter.timeStyle         = .short
        let formattedCreatedDate        = dateFormatter.string(from: createdDate)
        sectionTitle.attributedText     = .create(string: sectionTitleText,     font: .systemFont(ofSize: 15,weight: .bold),     color: .tertiaryLabel)
        createdOnLabel.attributedText   = .create(string: formattedCreatedDate ,font: .systemFont(ofSize: 10,weight: .semibold), color: .tertiaryLabel)
    }
    
    
}
