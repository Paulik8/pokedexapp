//
//  AuthViewController.swift
//  pokedexapp
//
//  Created by Paulik on 01/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    let authViewModel = AuthViewModel()

    override func viewDidLoad() {
        authViewModel.getDeviceSize()
        hideKeyboardAnywhereClicked()
        authViewModel.vc = self
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        authViewModel.checkKeyboardState()
    }
    
    func hideKeyboardAnywhereClicked() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        authViewModel.keyboardWillShow(keyboardSize: keyboardSize)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        authViewModel.keyboardWillHide() 
    }
    
    func setupListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

extension AuthViewController: AuthNotifier {
    
    @objc func buttonUp(height: CGFloat) {
    }
    
    @objc func buttonDown() {
    }
    
    @objc func buttonUpSmallScreen() {
        
    }
    
    @objc func buttonUpMediumScreen() {
        
    }
    
}
