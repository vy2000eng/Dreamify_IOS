//
//  SubscriptionViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 12/26/25.
//
import UIKit
import Foundation

class SubscriptionViewController: UIViewController {
    var subscriptionPageView:SubscriptionPageView
    
    init(){
        
        subscriptionPageView = SubscriptionPageView()
        
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        view.addSubview(subscriptionPageView)
        subscriptionPageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subscriptionPageView.topAnchor.constraint(equalTo: view.topAnchor),
            subscriptionPageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subscriptionPageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subscriptionPageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        subscriptionPageView.onClose = { [weak self] in
            // Handle close
            guard let self = self else{return}
            self.dismiss(animated: true)
        }
        
        subscriptionPageView.onCTA = { [weak self] in
            // Handle CTA button
        }
        subscriptionPageView.onUpgrade = { [weak self] in
            guard let self = self else { return }
            
    
            purchase(ProductID: "dreamify.monthly_subscription") { purchaseResult in
                DispatchQueue.main.async {
                    switch purchaseResult {
                    case .success(let isPro):
                        if isPro {
                   
                            APIClientManager.shared.authRequest(
                                endpoint: "/account/Subscribe",
                                method: "POST",
                                body: ["Subscribe": true],
                                type: GenericSuccessFailureResponse.self
                            ) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(_):
                                        TokenManager.shared.saveIsUserSubscribed(isUserSubscribed: true)
                                        self.dismiss(animated: true)
                                        
                                    case .failure(let err):
                                        TokenManager.shared.saveIsUserSubscribed(isUserSubscribed: false)
                                        let alert = UIAlertController(
                                            title: "Unable to Subscribe",
                                            message: err.localizedDescription,
                                            preferredStyle: .alert
                                        )
                                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                                        self.present(alert, animated: true)
                                    }
                                }
                            }
                        } else {
                            
                            let alert = UIAlertController(
                                title: "Subscription Issue",
                                message: "Purchase completed but subscription not active. Please contact support.",
                                preferredStyle: .alert
                            )
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true)
                        }
                        
                    case .failure(let error):
                        let alert = UIAlertController(
                            title: "Purchase Failed",
                            message: error.localizedDescription,
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
}

