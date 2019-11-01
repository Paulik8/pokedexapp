//
//  SignupViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 31/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import FirebaseAuth

class SignupViewModel {
    
    var addition = "@gmail.com"
    var signupVC: SignupNotifier?
    
    func handleSubmitClick(name: String, password: String) {
        let email = name.trimmingCharacters(in: .whitespaces).lowercased() + addition
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if (user != nil) {
                self.signupVC?.successSignup()
            }
        }
    }
    
}
