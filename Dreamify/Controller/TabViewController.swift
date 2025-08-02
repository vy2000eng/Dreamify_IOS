//
//  ViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit



class TabsViewController:UITabBarController{
    var mainViewController           : MainViewController
    var dreamRecordingViewController : DreamRecordingsViewController
    var calendarViewController       : CalendarViewController
    var dreamRecordingViewModel      : DreamRecordingViewModel
    
    
    
    init() {
        
        self.dreamRecordingViewModel      = DreamRecordingViewModel      (                                                )
        self.mainViewController           = MainViewController           (dreamRecordingViewModel: dreamRecordingViewModel)
        self.dreamRecordingViewController = DreamRecordingsViewController(dreamRecordingViewModel: dreamRecordingViewModel)
        self.calendarViewController       = CalendarViewController       (dreamRecordingViewModel: dreamRecordingViewModel)
        super.init                                                       (nibName                : nil, bundle: nil       )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {

        delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        mainViewController          .tabBarItem = UITabBarItem(title: "Home",        image: UIImage(systemName: "menucard"),    tag: 1)
        dreamRecordingViewController.tabBarItem = UITabBarItem(title: "Dreams", image: UIImage(systemName: "list.bullet"), tag: 2)
        calendarViewController      .tabBarItem = UITabBarItem(title: "Calendar",   image: UIImage(systemName: "calendar"), tag: 3)
        mainViewController.addNewRecordToDreamRecordingViewdelegate = dreamRecordingViewController
        setViewControllers(  [mainViewController,dreamRecordingViewController,calendarViewController], animated: true)

    }
  
}

