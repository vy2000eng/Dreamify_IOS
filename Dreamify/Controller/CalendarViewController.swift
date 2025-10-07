//
//  CalendarViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/8/25.
//

import Foundation
import UIKit
class CalendarViewController:UIViewController, RetrieveCurrentlySelectedDate, DeleteSectionFromCollectionView {

    func deleteRecording(id:UUID) {
        print("calendar vc delegate called")
        do{
            try self.dreamRecordingViewModel.removeDreamFromArray(id: id)//removeDreamByIDFromArray(id:id)//removeDreamFromArray(id: dream.id)
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                self.dreamRecordingView.collectionView.reloadData()//deleteSections(IndexSet(integer: indexPath.section))
            }
            
        }catch let err{
            print("an error occured whilst removing dream from collection view in dreamRecordingViewController: \(err)")
        }
      
  
       // self.
        
        
        
       
    }
    
    
    func retrieveCurrentlySelectedDate() -> Date {
        return current_date
    }
    
    var calendarView: CalendarView
    var dreamRecordingViewModel:DreamRecordingViewModel
    var dreamRecordingView: DreamRecordsView
    var current_date = Date()
    var dreamRecordingDataSourceManager:DreamRecordingViewDataSourceManager!
    private var calendarHeightConstraint: NSLayoutConstraint!
    private var isCalendarExpanded = true
    //weak var retreiveCurrentlySelectedDateDelegate:RetrieveCurrentlySelectedDate?

    
    
    
    
    init(){
        self.dreamRecordingViewModel = DreamRecordingViewModel(controllerManagedByDataSource: .CalendarViewController,curentlySelectedDate: current_date)
        self.dreamRecordingView = DreamRecordsView(frame: .zero)
        calendarView = CalendarView()
     
        
        super.init(nibName: nil, bundle: nil)
        dreamRecordingDataSourceManager = DreamRecordingViewDataSourceManager(dreamRecordingView: self.dreamRecordingView,dreamRecordingViewModel: self.dreamRecordingViewModel, controller: self)
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
        
    
       // dreamRecordingDataSourceManager.retrieveCurrentlySelectedDateDelegate = self
        //dreamRecordingDataSourceManager.deleteSectionFromCollectionViewDelegateInCalendarViewController = self
        
        
        dreamRecordingView.collectionView.delegate = dreamRecordingDataSourceManager
        dreamRecordingView.collectionView.dataSource = dreamRecordingDataSourceManager
        
        // Add subviews
        view.addSubview(calendarView)
        view.addSubview(dreamRecordingView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        dreamRecordingView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    private func setupConstraints() {
        calendarHeightConstraint = calendarView.heightAnchor.constraint(equalToConstant: 470)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarHeightConstraint,
            
            dreamRecordingView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 8),
            dreamRecordingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dreamRecordingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dreamRecordingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Add tap gesture to collapse/expand
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCalendar))
        calendarView.headerLabel.addGestureRecognizer(tapGesture)
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
        print("refresh called")
        do{
            dreamRecordingViewModel.dreams = try dreamRecordingViewModel.getAllDreamsCreatedByDate(seleectedDate: date)
            
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
    @objc private func toggleCalendar() {
        isCalendarExpanded.toggle()
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.calendarHeightConstraint.constant = self.isCalendarExpanded ? 470 : 50
            self.view.layoutIfNeeded()
        }
    }
    
}



