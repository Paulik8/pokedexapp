//
//  LoginViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 22/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewModel {
    
    let addition = "@gmail.com"
    var user: User?
    var loginVC: LoginNotifier?
    
    func checkUser() {
        DispatchQueue.main.async {
            guard let userData = AuthRepository.shared.getUser() else { return }
            self.signInUser(name: userData.name!, password: userData.password!)
        }
    }
    
    func handleSubmitClick(name: String, password: String) {
        DispatchQueue.main.async {
            self.signInUser(name: name, password: password)
        }
    }
    
    private func signInUser(name: String, password: String) {
        let email = convertNameToEmail(name)
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if (user != nil) {
                self.saveUser(email: email, password: password)
            }
        }
    }
    
    private func saveUser(email: String, password: String) {
        let name = convertEmailToName(email)
        if (self.user == nil) {
            self.user = User(name: name, password: password)
        } else {
            self.user?.name = name
            self.user?.password = password
        }
        AuthRepository.shared.saveUser(name: name, password: password) // Need some result to check one?
        self.loginVC?.successLogin()
    }
    
    func handleSignUpClick() {
        loginVC?.openSignUp()
    }
    
    private func convertNameToEmail(_  name: String) -> String { // Think of something(protocol, superclass)
        return name.trimmingCharacters(in: .whitespaces).lowercased() + addition
    }
    
    private func convertEmailToName(_ email: String) -> String { // Think of something(protocol, superclass)
        let index = email.count - addition.count
        return String(email.prefix(index))
    }
}
