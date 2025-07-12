//
//  ViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit



class TabsViewController:UITabBarController{
    var mainViewController          : MainViewController
    var dreamRecordingViewController: DreamRecordingsViewController
    var calendarViewController      : CalendarViewController
    
    
    
    init() {
        self.mainViewController           = MainViewController()
        self.dreamRecordingViewController = DreamRecordingsViewController()
        self.calendarViewController       = CalendarViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        mainViewController          .tabBarItem = UITabBarItem(title: "Home",        image: UIImage(systemName: "menucard"),    tag: 1)
        dreamRecordingViewController.tabBarItem = UITabBarItem(title: "Dreams", image: UIImage(systemName: "list.bullet"), tag: 2)
        calendarViewController      .tabBarItem = UITabBarItem(title: "Calendar",   image: UIImage(systemName: "calendar"), tag: 3)
        setViewControllers(  [mainViewController,dreamRecordingViewController,calendarViewController], animated: true)

    }
    
    
    
    
    
    
    
    
    
    
    
}

