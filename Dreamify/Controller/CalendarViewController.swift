//
//  CalendarViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/8/25.
//

import Foundation
import UIKit


class CalendarViewController:UIViewController{
    var calendarView: CalendarView
    var dreamRecordingViewModel:DreamRecordingViewModel
    init(dreamRecordingViewModel:DreamRecordingViewModel){
        
        self.dreamRecordingViewModel = dreamRecordingViewModel
        calendarView = CalendarView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    
    
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        title = "Calendar"
        
        // Add subviews
        view.addSubview(calendarView.calendar)
        
    }
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            // Title Label
            calendarView.calendar .centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarView.calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            calendarView.calendar.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            calendarView.calendar.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
        ])
        
    }
   
}


