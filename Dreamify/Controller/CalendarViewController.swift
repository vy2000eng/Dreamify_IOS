//
//  CalendarViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/8/25.
//

import Foundation
import UIKit
import CalendarKit


class CalendarViewController:UIViewController, RetrieveCurrentlySelectedDate, DeleteSectionFromCollectionView {

    func deleteRecording(id:UUID) {
        print("calendar vc delegate called")
        do{
            try self.dreamRecordingViewModel.removeDreamFromArray(id: id)
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                self.dreamRecordingView.collectionView.reloadData()
            }
            
        }catch let err{
            print("an error occured whilst removing dream from collection view in dreamRecordingViewController: \(err)")
        }

    }

    
    func retrieveCurrentlySelectedDate() -> Date {
        return current_date
    }
    
    var calendarView: CalendarView
    var dreamRecordingViewModel:DreamRecordingViewModel
    var dreamRecordingView: DreamRecordsView
    var current_date = Date()
    var dreamRecordingDataSourceManager:DreamRecordingViewDataSourceManager!
    private var scrollViewHeightConstraint: NSLayoutConstraint!
    private var isCalendarExpanded = true
    private var calendarButton: UIButton?

    
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
        navigationItem.leftBarButtonItem = createLeftOptionsBarButtonItem()


    }
    

    private func setupUI(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationItem.largeTitleDisplayMode = .never
   
        dreamRecordingView.collectionView.delegate = dreamRecordingDataSourceManager
        dreamRecordingView.collectionView.dataSource = dreamRecordingDataSourceManager

        view.addSubview(calendarView)
        view.addSubview(dreamRecordingView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        dreamRecordingView.translatesAutoresizingMaskIntoConstraints = false
    }
    

    private func setupConstraints() {
        scrollViewHeightConstraint = calendarView.heightAnchor.constraint(equalToConstant: 350)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewHeightConstraint,
            
            dreamRecordingView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 2),
            dreamRecordingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dreamRecordingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dreamRecordingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Add tap gesture to the entire header stack
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCalendar))
        calendarView.headerStack.addGestureRecognizer(tapGesture)
        calendarView.chevronButton.addTarget(self, action: #selector(toggleCalendar), for: .touchUpInside)
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


    
        func createLeftOptionsBarButtonItem() -> UIBarButtonItem {
            let button = UIButton(type: .system)

            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "chevron.down")
            config.imagePlacement = .trailing
            config.imagePadding = 8
            config.baseForegroundColor = .systemBlue
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

            var titleAttr = AttributedString("Dream Calendar")
            titleAttr.font = .systemFont(ofSize: 15, weight: .semibold)
            config.attributedTitle = titleAttr

            let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
            config.preferredSymbolConfigurationForImage = imageConfig

            button.configuration = config
            button.addTarget(self, action: #selector(toggleCalendar), for: .touchUpInside)
            
            // Store reference
            self.calendarButton = button
            
            return UIBarButtonItem(customView: button)
        


    }

    
    
    @objc private func toggleCalendar() {
        isCalendarExpanded.toggle()
        if (isCalendarExpanded){
            guard var config = calendarButton?.configuration else { return }
            
            // Change the chevron (example)
            config.image = UIImage(systemName: "chevron.down") // or whatever you need
            
            calendarButton?.configuration = config
            
        }else{
            guard var config = calendarButton?.configuration else { return }
            
            // Change the chevron (example)
            config.image = UIImage(systemName: "chevron.up") // or whatever you need
            
            calendarButton?.configuration = config
            
        }
        
        let targetHeight: CGFloat = isCalendarExpanded ? 350 : 0
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5) {
            self.scrollViewHeightConstraint.constant = targetHeight
            self.calendarView.setExpanded(self.isCalendarExpanded)
            self.view.layoutIfNeeded()
        }
    }
    
}



