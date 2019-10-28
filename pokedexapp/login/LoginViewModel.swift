//
//  LoginViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 22/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewModel {
    
    let addition = "@gmail.com"
    var loginVC: LoginNotifier?
    
    func handleButtonClick(name: String, password: String) {
        let email = name.lowercased() + addition
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if (user != nil) {
                self.loginVC?.successLogin()
            }
        }
    }
    
}
