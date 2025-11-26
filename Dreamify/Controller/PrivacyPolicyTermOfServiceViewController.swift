//
//  PrivacyPolicyTermOfServiceViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/20/25.
//

import UIKit

class PrivacyPolicyTermsOfServiceController: UIViewController {
    
    var termsOfServicePrivacyPolicy: String
    var privacyPolicyTermsOfServiceView: PrivacyPolicyTermsOfServiceView
    
    init(privacyPolicyTermsOfService: Int) {
        let privacyPolicyTermsOfServiceStruct = PrivacyPolicyTermsOfServiceStruct()
        
        if privacyPolicyTermsOfService == 0 {
            termsOfServicePrivacyPolicy = privacyPolicyTermsOfServiceStruct.privacyPolicy
            self.privacyPolicyTermsOfServiceView = PrivacyPolicyTermsOfServiceView(
                frame: .zero,
                contentText: termsOfServicePrivacyPolicy
            )
            super.init(nibName: nil, bundle: nil)
            self.title = "Privacy Policy"
        } else {
            termsOfServicePrivacyPolicy = privacyPolicyTermsOfServiceStruct.termsOfService
            self.privacyPolicyTermsOfServiceView = PrivacyPolicyTermsOfServiceView(
                frame: .zero,
                contentText: termsOfServicePrivacyPolicy
            )
            super.init(nibName: nil, bundle: nil)
            self.title = "Terms of Service"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(privacyPolicyTermsOfServiceView)
        
        privacyPolicyTermsOfServiceView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            privacyPolicyTermsOfServiceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            privacyPolicyTermsOfServiceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            privacyPolicyTermsOfServiceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            privacyPolicyTermsOfServiceView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
