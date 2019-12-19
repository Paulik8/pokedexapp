//
//  SignupViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 31/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import FirebaseAuth
import RealmSwift

class SignupViewModel {
    
    var addition = "@gmail.com"
    var signupVC: SignupNotifier?
    var userData: User?
    let errorHandler = ErrorHandler()
    var notification: NotificationToken?
    
    func handleSubmitClick(name: String, password: String) {
        let email = convertNameToEmail(name)
        signUp(email: email, password: password)
    }
    
    private func signUp(email: String, password: String) {
        let app = (UIApplication.shared.delegate as? AppDelegate)
        let ref = app?.ref
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let userError = err {
                let errorStr = self.errorHandler.handleAuthError(error: userError)
                self.signupVC?.showError(error: errorStr)
                print(userError)
                return
            }
            guard let uid = result?.user.uid else { return } // Need uid in local database?
            
            ref?.child("users").child(uid).setValue(["name": email, "password": password, "imageUrl": ""], withCompletionBlock: { (err, ref) in
                    if let dbErr = err {
                        print (dbErr)
                        return
                    }
                    self.saveUser(email: email, password: password) // should update attributes in local database table "users"
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
        let rep = AuthRepository.shared
        rep.saveUser(name: name, password: password, imageUrl: "") // Need some result to check one?
        notification = rep.dbRef?.objects(User.self).observe { (changes) in
            switch changes {
            case .initial:
                break
            case .update(let results, let deletions, let insertions, let modifications):
                if (insertions.count == 1) {
                    self.signupVC?.successSignup()
                }
            case .error(let error):
                print ("error")
                fatalError("\(error)")
            }
        }
    }
    
    func unsubscribe() {
        notification?.invalidate()
    }

    private func convertNameToEmail(_  name: String) -> String { // Think of something(protocol, superclass)
        return name.trimmingCharacters(in: .whitespaces).lowercased() + addition
    }
    
    private func convertEmailToName(_ email: String) -> String { // Think of something(protocol, superclass)
        let index = email.count - addition.count
        return String(email.prefix(index))
    }
    
}
