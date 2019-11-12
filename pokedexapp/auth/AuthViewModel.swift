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
    let model = UIDevice.modelName
    var deviceSize: String?
    
    func submitButtonDowm() {
        vc?.buttonDown()
    }
    
    func keyboardWillShow(keyboardSize: CGRect) {
        if (!isKeyboardActive) {
            isKeyboardActive = true
            let height = keyboardSize.height
            handleKeyboard(keyboard: height)
        }
    }
    
    func keyboardWillHide() {
        if (isKeyboardActive) {
            isKeyboardActive = false
            vc?.buttonDown()

        }
    }
    
    func getDeviceSize() {
        let small = "small"
        let medium = "medium"
        let big = "big"
        switch model {
        case "iPhone SE":
            deviceSize = small
        case "Simulator iPhone SE":
            deviceSize = small
        case "iPhone 6s":
            deviceSize = medium
        default:
            deviceSize = big
        }
    }
    
    private func handleKeyboard(keyboard height: CGFloat) {
        if (deviceSize == "small") {
            vc?.buttonUpSmallScreen()
        } else if (deviceSize == "medium") {
            vc?.buttonUpMediumScreen()
        } else if (deviceSize == "big") {
            vc?.buttonUp(height: height)
        }
    }
    
}
