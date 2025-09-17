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
    var dreamRecordingView: DreamRecordsView
   // var dreamRecordingsViewController:DreamRecordingsViewController
    var dreamRecordingDataSourceManage:DreamRecordingViewDataSourceManager!
    
    init(dreamRecordingViewController:DreamRecordingsViewController){
        //self.dre
        self.dreamRecordingViewModel = DreamRecordingViewModel()
        self.dreamRecordingView = DreamRecordsView(frame: .zero)
        calendarView = CalendarView()
        //self.dreamRecordingsViewController = dreamRecordingViewController
        
        
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        dreamRecordingDataSourceManage = DreamRecordingViewDataSourceManager(dreamRecordingView: dreamRecordingView, dreamRecordingViewModel: dreamRecordingViewModel, controller: self)

        setupUI()
        setupConstraints()
    }

    
    
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        title = "Calendar"

        calendarView.calendar.delegate = self
        dreamRecordingView.collectionView.delegate = dreamRecordingDataSourceManage
        dreamRecordingView.collectionView.dataSource = dreamRecordingDataSourceManage
        
        // Add subviews
        view.addSubview(calendarView)
        view.addSubview(dreamRecordingView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        dreamRecordingView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 600), // Give it a fixed height

           // calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            dreamRecordingView.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
            dreamRecordingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dreamRecordingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dreamRecordingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            
            
        ])
        
    }
    
    
    
   
}

extension CalendarViewController:UICalendarViewDelegate{
      //  cale
}


