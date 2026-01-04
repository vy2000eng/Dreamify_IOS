//
//  EmailVerififcationController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 12/10/25.
//
import UIKit

class EmailVerififcationController:UIViewController{
    var emailVerificationView:VerificationCodeView;
    
    init(){
        self.emailVerificationView = VerificationCodeView(frame: .zero);
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        setupView();
        emailVerificationView.onCodeComplete = { [weak self] code in
            
            guard let self = self else{return}
            sendVerificationCodeToBackend(code:code)
        }
    }

    private func setupView(){
        view.addSubview(emailVerificationView);
        emailVerificationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailVerificationView.topAnchor.constraint(equalTo: view.topAnchor),
            emailVerificationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emailVerificationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emailVerificationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            
        ]);
        setupNavigationBar();
        
    }
    private func setupNavigationBar() {
        title = "Verify Email Account"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )

        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func sendVerificationCodeToBackend(code:String){
        
        APIClientManager.shared.authRequest(endpoint: "/account/VerifyUserAccount", method: "POST",body:["VerificationRequestCode":code,"Email":TokenManager.shared.getUserEmail()], type: GenericSuccessFailureResponse.self, completion: {[weak self] result in
            guard let self = self else {return}
            
            
            switch result{
            case .success(let response):
                print("THIS IS THE RESPONSE FROM THE VERIFY ENDPOINT: \(response.result)")
                
                
                DispatchQueue.main.async{ [weak self] in
                    guard let self = self else {return}
                    navigateToScreenBasedOnResponse(isSuccess: true)

                    
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async{ [weak self] in
                    guard let self = self else{ return}
                    
                    navigateToScreenBasedOnResponse(isSuccess: false)
                }
            }
        })
    }
    
    func navigateToScreenBasedOnResponse(isSuccess:Bool){
        let vc = isSuccess ? TabsViewController() : LoginViewController()

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UINavigationController(rootViewController: vc)
            window.makeKeyAndVisible()
        }
        
    }
    
    
    
    
    
    
    @objc private func cancelButtonTapped() {

            let alert = UIAlertController(
                title: "Don't Verify Email?",
                message: "You will not be able to do certain actions, such as changing updating your email, resetting your password, or deleting your account",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
                //self?.dismiss(animated: true)
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    let mainViewController = TabsViewController()
                    window.rootViewController = UINavigationController(rootViewController: mainViewController)
                    window.makeKeyAndVisible()
                }
                
            })
            present(alert, animated: true)
    }
}
