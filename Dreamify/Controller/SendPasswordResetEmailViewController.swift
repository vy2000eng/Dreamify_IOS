//
//  ResetPasswordFlowViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 12/13/25.
//


import UIKit
public class SendPasswordResetEmailViewController: UIViewController {
    var sendPasswordresetEmailView:SendPasswordResetView
    
//    var onResetPasswordTapped: (() -> Void)?
//    var onSaveChangesTapped: ((String) -> Void)?
    
    
    
    init() {
        self.sendPasswordresetEmailView = SendPasswordResetView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        sendPasswordresetEmailView.onSendCodeButtonTapped = { [weak self] email in
            
            guard let self = self else {return}
            
            
            print("password reset button tapped")
            sendPasswordResetEmail(email: email)
            
            
            
            
            
        }

        
    }
    
    
    private func setupUI(){
        view.addSubview(sendPasswordresetEmailView)
        sendPasswordresetEmailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            
            sendPasswordresetEmailView.topAnchor.constraint(equalTo: view.topAnchor),
            sendPasswordresetEmailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sendPasswordresetEmailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sendPasswordresetEmailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            

        
        ])
        
        
        
    }
    public func sendPasswordResetEmail(email: String){
        print("in send password reset func")
        
        
        
        APIClientManager.shared.request(endpoint: "/account/ForgotPassword", method: "POST", body: ["Email":email],type: GenericSuccessFailureResponse.self, completion: { [weak self] result in
            guard let self = self else {return}
            
            switch result{
            case .success(let response):
                print("request sent succesfully")
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    let vc = ResetPasswordViewController()//ResetPasswordViewController(frame: .zero)

                    navigationController?.pushViewController(vc, animated: true)

                    
                    
                }
                
                
                
                
                
                
            case .failure(let error):
                print("request error: \(error)")

                let alert = UIAlertController(title: "Forgot Password Failure", message: "The forgot password action was unsucessful because \(error)", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak self] UIAlertAction in
                    guard let self = self else{return}
                    DispatchQueue.main.async {[weak self] in
                        
                        guard let self = self else { return }
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            let mainViewController = LoginViewController()
                            window.rootViewController = UINavigationController(rootViewController: mainViewController)
                            window.makeKeyAndVisible()
                        }
                        
                    }
                    
                    
                    
                    
                    
                }))
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else{return}
                    present(alert, animated: true)

                    
                }


                
            }
            
            
            
        })
        
        
    }
    
    
    
    
    
    
    
}
