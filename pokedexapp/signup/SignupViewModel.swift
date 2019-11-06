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
    var userData: User?
    
    func handleSubmitClick(name: String, password: String) {
        let email = convertNameToEmail(name)
        DispatchQueue.main.async {
            self.signUp(email: email, password: password)
        }
    }
    
    private func signUp(email: String, password: String) {
        let app = (UIApplication.shared.delegate as? AppDelegate)
        let ref = app?.ref
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let userError = err {
                print(userError)
                return
            }
            guard let uid = result?.user.uid else { return } // Need uid in local database?
            
//            guard let uploadData = img.pngData() else { return }
            
//            let logoStorage = app?.storage.reference().child("logo").child("logo.png")
//            storage?.putData(uploadData, metadata: nil, completion: { (metadata, err) in
//                if let storageError = err {
//                    print(storageError)
//                    return
//                }

//            logoStorage?.downloadURL(completion: { (url, err) in
//                if let urlError = err {
//                    print(urlError)
//                    return
//                }
//                guard let imageUrl = url else { return }
            
            ref?.child("users").child(uid).setValue(["name": email, "password": password, "imageUrl": ""], withCompletionBlock: { (err, ref) in
                    if let dbErr = err {
                        print (dbErr)
                        return
                    }
                    self.saveUser(email: email, password: password) // should update attributes in local database table "users"
                    self.signupVC?.successSignup()
                })
                
//            })
                
//            }) //
            
            
        }
    }
    
    private func saveUser(email: String, password: String) {
        let name = convertEmailToName(email)
        if (self.userData == nil) { // extra because should clear user after log out
            self.userData = User(name: name, password: password, imageUrl: "")
        } else {
            self.userData?.name = name
            self.userData?.password = password
            self.userData?.imageUrl = ""
        }
        AuthRepository.shared.saveUser(name: name, password: password, imageUrl: "") // Need some result to check one?
    }

    private func convertNameToEmail(_  name: String) -> String { // Think of something(protocol, superclass)
        return name.trimmingCharacters(in: .whitespaces).lowercased() + addition
    }
    
    private func convertEmailToName(_ email: String) -> String { // Think of something(protocol, superclass)
        let index = email.count - addition.count
        return String(email.prefix(index))
    }
    
}
