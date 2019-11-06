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
            let name = userData.name
            let password = userData.password
            let imageUrl = userData.imageUrl
            if (self.user == nil) {
                self.user = User(name: name, password: password, imageUrl: imageUrl)
            } else {
                self.user?.name = name
                self.user?.password = password
                self.user?.imageUrl = imageUrl
            }
            self.loginVC?.successLogin()
//            self.signInUser(name: userData.name!, password: userData.password!)
        }
    }
    
    func handleSubmitClick(name: String, password: String) {
        DispatchQueue.main.async {
            self.signInUser(name: name, password: password)
        }
    }
    
    private func signInUser(name: String, password: String) {
        let email = convertNameToEmail(name)
        Auth.auth().signIn(withEmail: email, password: password) { (res , err) in
            if (res != nil) {
                let ref = (UIApplication.shared.delegate as? AppDelegate)?.ref
                guard let uid = res?.user.uid  else { return }
                ref?.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let name = value?["name"] as? String
                    let password = value?["password"] as? String
                    let imageUrl = value?["imageUrl"] as? String ?? ""
                    self.saveUser(email: name!, password: password!, imageUrl: imageUrl)
                })
            }
        }
    }
    
    private func saveUser(email: String, password: String, imageUrl: String) {
        let name = convertEmailToName(email)
        if (self.user == nil) {
            self.user = User(name: name, password: password, imageUrl: imageUrl)
        } else {
            self.user?.name = name
            self.user?.password = password
            self.user?.imageUrl = imageUrl
        }
        AuthRepository.shared.saveUser(name: name, password: password, imageUrl: imageUrl) // Need some result to check one?
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
