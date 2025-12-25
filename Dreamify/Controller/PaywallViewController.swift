//
//  PaywallViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 12/14/25.
//

import UIKit
import RevenueCat
import RevenueCatUI

class payWallViewController: UIViewController {
    @IBAction func presentPaywall() {
        let controller = PaywallViewController()
        present(controller, animated: true, completion: nil)
    }
}
