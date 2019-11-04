//
//  AuthViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 03/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class AuthViewModel {
    
    var vc: AuthNotifier?
    var isKeyboardActive = false
    
    func submitButtonDowm() {
        vc?.buttonDown()
    }
    
    func keyboardWillShow(keyboardSize: CGRect) {
        if (!isKeyboardActive) {
            print("view", isKeyboardActive)
            isKeyboardActive = true
            let height = keyboardSize.height
            vc?.buttonUp(height: height)
        }
    }
    
    func keyboardWillHide() {
        if (isKeyboardActive) {
            isKeyboardActive = false
            vc?.buttonDown()
        }
    }
}
