//
//  ViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit
import BackgroundTasks







class TabsViewController:UITabBarController{
    let taskId = "dreamify.refreshAuthToken.backgroundTask"
    
    var mainViewController           : MainViewController
    var dreamRecordingViewController : DreamRecordingsViewController
    var calendarViewController       : CalendarViewController
    //var dreamRecordingViewModel      : DreamRecordingViewModel
    
    
    
    init() {
        
      //  self.dreamRecordingViewModel      = DreamRecordingViewModel      (                                                )
        self.mainViewController           = MainViewController           ()
        self.dreamRecordingViewController = DreamRecordingsViewController()
        self.calendarViewController       = CalendarViewController       (dreamRecordingViewController: dreamRecordingViewController)
        
        self.mainViewController.navigationItem.largeTitleDisplayMode           = .automatic
        self.dreamRecordingViewController.navigationItem.largeTitleDisplayMode = .automatic
        self.calendarViewController.navigationItem.largeTitleDisplayMode       = .automatic
        
        super.init                                                       (nibName                : nil, bundle: nil       )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        print("actual vc appeared")
        super.viewDidLoad()

        
        let nav1 = UINavigationController(rootViewController: mainViewController)
        let nav2 = UINavigationController(rootViewController: dreamRecordingViewController)
        let nav3 = UINavigationController(rootViewController: calendarViewController)
        
        nav1.tabBarItem = UITabBarItem(title: "Home",  image: UIImage(systemName: "menucard"),tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Dreams",image: UIImage(systemName: "list.bullet"),tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Calendar",image: UIImage(systemName: "calendar"), tag: 3)
        var count = 0;
        
        for nav in [nav1, nav2, nav3] {
            
                nav.navigationBar.prefersLargeTitles                             = true
                nav.navigationController?.navigationBar.titleTextAttributes      = [.foregroundColor: UIColor.white,.font: UIFont.systemFont(ofSize: 16,weight: .regular) ]
                nav.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 24,weight: .bold) ]
                nav.navigationController?.navigationBar.layoutMargins            = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            
        
        }
        setViewControllers([nav1, nav2, nav3, ], animated: true)
                                             

        //mainViewController.addNewRecordToDreamRecordingViewdelegate = dreamRecordingViewController.dreamRecordingDataSourceManager
        
    }
}

  

//let taskId = "dreamify.refreshAuthToken.backgroundTask"
//e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"dreamify.refreshAuthToken.backgroundTask"]

