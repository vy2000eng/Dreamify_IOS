//
//  Utils.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/13/25.
//

import Foundation
import UIKit
import RevenueCat



extension NSAttributedString {
    static func create(string: String, font: UIFont, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [.font: font, .foregroundColor: color])
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func purchase(ProductID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
    Task {
        do {
            print("🔵 Step 1: Fetching products for: \(ProductID)")
            let products = await Purchases.shared.products([ProductID])
            
            print("🔵 Step 2: Products found: \(products.count)")
            guard let product = products.first else {
                print("🔴 No product found!")
                completion(.failure(NSError(domain: "Purchase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
                return
            }
            
            print("🔵 Step 3: Product details: \(product.productIdentifier) - \(product.localizedTitle)")
            print("🔵 Step 4: Calling Purchases.shared.purchase()...")
            
            let result = try await Purchases.shared.purchase(product: product)
            
            print("🟢 Step 5: Purchase call completed!")
            
            if result.userCancelled {
                print("🟡 User cancelled")
                completion(.failure(NSError(domain: "Purchase", code: -2, userInfo: [NSLocalizedDescriptionKey: "Purchase was cancelled"])))
                return
            }
            
            let customerInfo = result.customerInfo
            let isPro = !customerInfo.activeSubscriptions.isEmpty
            
            print("🟢 Purchase completed. isPro: \(isPro)")
            print("🟢 Active subscriptions: \(customerInfo.activeSubscriptions)")
            
            completion(.success(isPro))
            
        } catch {
            print("🔴 Purchase error at some step: \(error)")
            completion(.failure(error))
        }
    }
}

func checkSubscriptionStatus() async {
    do {
        let customerInfo = try await Purchases.shared.customerInfo()
        let isPro = !customerInfo.activeSubscriptions.isEmpty
        
        print("🟢 Subscription status: isPro = \(isPro)")
        print("🟢 Active subscriptions: \(customerInfo.activeSubscriptions)")
        
        // Update local storage
        TokenManager.shared.saveIsUserSubscribed(isUserSubscribed: isPro)
        
        // Sync with your backend
        APIClientManager.shared.authRequest(
            endpoint: "/account/Subscribe",
            method: "POST",
            body: ["Subscribe": isPro],
            type: GenericSuccessFailureResponse.self
        ) { result in
            switch result {
            case .success(let response):
                print("✅ Backend subscription status synced: \(response.result)")
                
            case .failure(let error):
                print("❌ Failed to sync subscription status: \(error.localizedDescription)")
            }
        }
        
    } catch {
        print("❌ Error checking subscription: \(error)")
    }
}

    
    


        
 
    

func unsubscribe(ProductID: String)async throws -> Void{
    var customerInfo:CustomerInfo?
   // Task{
        
    let products:[StoreProduct] = await Purchases.shared.products([ProductID])
    guard let product = products.first else { return }
    //let result = try await Purchases.shared.restorePurchases(completion: <#T##((CustomerInfo?, PublicError?) -> Void)?##((CustomerInfo?, PublicError?) -> Void)?##(CustomerInfo?, PublicError?) -> Void#>)//purchase(product: product)
    
    
    
    
    
}

func checkEntitlement() async throws->Bool {
  
        let customerInfo = try await Purchases.shared.customerInfo()
        if customerInfo.entitlements.all["Dreamify Pro"]?.isActive == true {
            return true
        }
        return false

}



