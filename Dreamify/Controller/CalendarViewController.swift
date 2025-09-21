//
//  CalendarViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/8/25.
//

import Foundation
import UIKit
class CalendarViewController:UIViewController, RetrieveCurrentlySelectedDate {
    func retrieveCurrentlySelectedDate() -> Date {
        return current_date
    }
    
    
    
    
    
    var calendarView: CalendarView
    var dreamRecordingViewModel:DreamRecordingViewModel
    var dreamRecordingView: DreamRecordsView
    var current_date = Date()
    var dreamRecordingDataSourceManager:DreamRecordingViewDataSourceManager!
    weak var retreiveCurrentlySelectedDateDelegate:RetrieveCurrentlySelectedDate?
    
    
    init(){
        self.dreamRecordingViewModel = DreamRecordingViewModel(controllerManagedByDataSource: .CalendarViewController)
        
        self.dreamRecordingView = DreamRecordsView(frame: .zero)
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
        setupCalendarSelection()
        
        
    }
    
    
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        title = ""
        
        dreamRecordingDataSourceManager = DreamRecordingViewDataSourceManager(
            dreamRecordingView: self.dreamRecordingView,
            dreamRecordingViewModel: self.dreamRecordingViewModel,
            controller: self
        )
        dreamRecordingDataSourceManager.retrieveCurrentlySelectedDateDelegate = self
        
        
        dreamRecordingView.collectionView.delegate = dreamRecordingDataSourceManager
        dreamRecordingView.collectionView.dataSource = dreamRecordingDataSourceManager
        
        // Add subviews
        view.addSubview(calendarView)
        view.addSubview(dreamRecordingView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        dreamRecordingView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Give calendar less space, collection view more
            calendarView.topAnchor.constraint(equalTo: view.topAnchor,constant: -20),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6), // 40% instead of 50%
            
            dreamRecordingView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 4),
            dreamRecordingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dreamRecordingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dreamRecordingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    private func setupCalendarSelection() {
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        
        
        let date = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            year: Calendar.current.component(.year, from: Date.now),
            month: Calendar.current.component(.month, from: Date.now),
            day: Calendar.current.component(.day, from: Date.now)
        )
        
        dateSelection.selectedDate = date
        
        calendarView.calendar.selectionBehavior = dateSelection
        calendarView.calendar.delegate = self
        let selected = Calendar.current.date(from: date)!
        
    }
    
    func filterDreamsForDate(_ date: Date) {
        do{
            try dreamRecordingViewModel.getAllDreamsCreatedByDate(seleectedDate: date)
            
            DispatchQueue.main.async { [weak self] in
                UIView.animate(withDuration: 0.1) {
                    self?.dreamRecordingView.collectionView.alpha = 0.5
                } completion: { _ in
                    self?.dreamRecordingView.collectionView.reloadData()
                    UIView.animate(withDuration: 0.1) {
                        self?.dreamRecordingView.collectionView.alpha = 1.0
                    }
                }
            }
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
        }catch let err as NSError{
            
            let alert = UIAlertController(title: err.domain,
                                          message: err.description,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.present(alert, animated: true)
            
        }
        
    }
}



