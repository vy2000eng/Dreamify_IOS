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


func purchase(ProductID: String) async throws -> Void {
    var isPro :Bool = false
    var customerInfo:CustomerInfo?
   // Task{
        
    let products:[StoreProduct] = await Purchases.shared.products([ProductID])
    guard let product = products.first else { return }
    let result = try await Purchases.shared.purchase(product: product)

    customerInfo = result.customerInfo
    isPro = customerInfo?.entitlements.active.contains(where: {$0.value.isActive}) ?? false
            
            
        
    //}
}

//func checkEntitlement() async {
//    do {
//        let customerInfo = try await Purchases.shared.customerInfo()
//        if customerInfo.entitlements.all["Dreamify Pro"]?.isActive == true {
//            // User has access to entitlement
//        }
//    } catch {
//        print("Error: \(error)")
//    }
//}



