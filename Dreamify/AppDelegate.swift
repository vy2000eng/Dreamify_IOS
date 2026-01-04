//
//  AppDelegate.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 6/22/25.
//

import GoogleSignIn
import UIKit
import CoreData
import BackgroundTasks
import RevenueCat

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let taskId = "dreamify.refreshAuthToken.backgroundTask"
    
    // MARK: - URL Handling
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("=== APP DELEGATE URL RECEIVED ===")
        print("URL: \(url)")
        let handled = GIDSignIn.sharedInstance.handle(url)
        print("Google handled: \(handled)")
        return handled
    }
    
    // MARK: - App Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure RevenueCat
        Purchases.configure(withAPIKey: "appl_rvOzclRhReUCbWQDKxJnrUOcFki")
        
        // Configure Google Sign In
        if let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String {
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            print("Google Sign In configured with client ID: \(clientID)")
        } else {
            print("ERROR: GIDClientID not found in Info.plist")
        }
        
        // Register background task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { task in
            guard let refreshTask = task as? BGAppRefreshTask else { return }
            self.handleBackgroundTask(task: refreshTask)
        }
        schedule()
        
        // Check if we have a refresh token
        guard let refreshToken = TokenManager.shared.getRefreshToken(), !refreshToken.isEmpty else {
            print("No refresh token available, skipping token refresh")
            restoreGoogleSignIn()
            return true
        }
        
        // Refresh auth token
        refreshAuthToken()
        
        // Restore Google Sign In
        restoreGoogleSignIn()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        schedule()
        refreshAuthToken()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        checkIfLoginNeeded()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        checkIfLoginNeeded()
        
        // Check subscription status if user is logged in
        if TokenManager.shared.getAccessToken() != nil {
            Task {
                await checkSubscriptionStatus()
            }
        }
    }
    
    // MARK: - Scene Configuration

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // MARK: - Core Data

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Dreamify")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Background Tasks
    
    private func schedule() {
        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            print("Scheduled tasks: \(requests.count)")
            
            guard requests.isEmpty else { return }
            
            do {
                let newTask = BGAppRefreshTaskRequest(identifier: self.taskId)
                newTask.earliestBeginDate = Date().addingTimeInterval(15 * 60)
                try BGTaskScheduler.shared.submit(newTask)
                print("Background task scheduled")
            } catch {
                print("Failed to schedule background task: \(error)")
            }
        }
    }
    
    private func handleBackgroundTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
            print("Background task expired")
            task.setTaskCompleted(success: false)
        }
        
        APIClientManager.shared.refreshToken { refreshResult in
            switch refreshResult {
            case .success(let response):
                print("Background token refresh successful")
                TokenManager.shared.saveAccessToken(response.accessToken)
                TokenManager.shared.saveRefreshToken(response.refreshToken)
                self.schedule()
                task.setTaskCompleted(success: true)
                
            case .failure(let err):
                print("Background token refresh failed: \(err)")
                TokenManager.shared.clearTokens()
                UserSettings.shared.setLoginState(false)
                task.setTaskCompleted(success: false)
            }
        }
    }
    
    // MARK: - Auth & Login
    
    private func refreshAuthToken() {
        APIClientManager.shared.refreshToken { refreshResult in
            switch refreshResult {
            case .success(let response):
                print("Token refresh successful")
                TokenManager.shared.saveAccessToken(response.accessToken)
                TokenManager.shared.saveRefreshToken(response.refreshToken)
                
                // Check subscription after token refresh
                Task {
                    await checkSubscriptionStatus()
                }
                
            case .failure(let err):
                print("Token refresh failed: \(err)")
                TokenManager.shared.clearTokens()
                UserSettings.shared.setLoginState(false)
                self.navigateToLogin()
            }
        }
    }
    
    private func restoreGoogleSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                print("No previous Google sign in found")
            } else {
                print("Google sign in restored")
            }
        }
    }
    
    internal func checkIfLoginNeeded() {
        if TokenManager.shared.getAccessToken() == nil && TokenManager.shared.getRefreshToken() == nil {
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
