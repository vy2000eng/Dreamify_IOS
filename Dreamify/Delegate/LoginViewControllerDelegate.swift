//
//  LoginViewControllerDelegate.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/1/25.
//

import UIKit

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.emailTextField {
            loginView.passwordTextField.becomeFirstResponder()
        } else if textField == loginView.passwordTextField {
            loginButtonTapped()
        }
        
        return true
    }
}
