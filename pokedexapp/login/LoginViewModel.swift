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
    
    func checkUser() {
        DispatchQueue.main.async {
            AuthRepository.shared.getUser()
        }
    }
    
    func handleSubmitClick(name: String, password: String) {
        let email = name.trimmingCharacters(in: .whitespaces).lowercased() + addition
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if (user != nil) {
                self.saveUser(email: email, password: password)
            }
        }
    }
    
    private func saveUser(email: String, password: String) {
        let index = email.count - addition.count
        let name = String(email.prefix(index))
        DispatchQueue.main.async {
            AuthRepository.shared.saveUser(name: name, password: password)
            self.checkUser()
            self.loginVC?.successLogin()
        }
    }
    
    func handleSignUpClick() {
        loginVC?.openSignUp()
    }
    
}
