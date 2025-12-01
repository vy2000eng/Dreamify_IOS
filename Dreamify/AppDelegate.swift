//
//  AppDelegate.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import UIKit
import CoreData
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let taskId = "dreamify.refreshAuthToken.backgroundTask"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil){ task in
            guard let newTask = task as? BGAppRefreshTask  else {return}
            self.handleTask(task: newTask)
            
        }

        
         schedule()
        

        
        
        
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Schedule when app goes to background
           schedule()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Optionally reschedule when app comes to foreground
        checkIfLoginNeeded()

        schedule()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Also check when app becomes active
        checkIfLoginNeeded()
    }

    


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Dreamify")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    //MARK: - tasks
    private func schedule(){
        // BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskId)
        BGTaskScheduler.shared.getPendingTaskRequests{ requests in
            print("scheduled tasks  \(requests.count)")
            
            
            guard requests.isEmpty else{
                
                return
            }
            
            do{
                let newTask = BGAppRefreshTaskRequest(identifier: self.taskId)
                newTask.earliestBeginDate = Date().addingTimeInterval(15 * 60)
                try BGTaskScheduler.shared.submit(newTask)
                
                print("task scheduled")
                
                
            }catch{
                print("failed to schedule \(error)")
                
            }
            
            
        }
    }
    private func handleTask(task:BGAppRefreshTask){
        task.expirationHandler = {
               print("Background task expired")
               task.setTaskCompleted(success: false)
           }
       
        
        APIClientManager.shared.refreshToken{ refreshResult in
            switch refreshResult{
                
            case .success(let response):
                print("token refresh was executed successfully")
                TokenManager.shared.saveAccessToken(response.accessToken)
                TokenManager.shared.saveRefreshToken(response.refreshToken)
                
                self.schedule()
                
                task.setTaskCompleted(success: true)

           
                
            case .failure(let err):
                print("Token refresh failed: \(err)")
                TokenManager.shared.clearTokens()
                UserSettings.shared.setLoginState(false)
                task.setTaskCompleted(success: false)
            }
            
        }
    }
    internal func checkIfLoginNeeded() {
        if !UserSettings.shared.userLoginState {
            DispatchQueue.main.async {
                self.navigateToLogin()
            }
        }
    }
    private func navigateToLogin() {
        let loginViewController = LoginViewController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UINavigationController(rootViewController: loginViewController)
            window.makeKeyAndVisible()
        }
    }
}

