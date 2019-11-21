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
import RealmSwift

class LoginViewModel {
    
    let addition = "@gmail.com"
    var user: User?
//    {
//        didSet {
//            self.loginVC?.successLogin()
//        }
//    }
    private var notification: NotificationToken?
    
    var loginVC: LoginNotifier?
    let errHandler = ErrorHandler()
    
    func checkUser() {
        let rep = AuthRepository.shared
        guard let userData = rep.getUser() else { return }
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
    }
    
    func handleSubmitClick(name: String, password: String, _ handler: @escaping () -> Void) {
        
//        saveUser(email: convertNameToEmail(name), password: password, imageUrl: "")
//        DispatchQueue.main.async {
        signInUser(name: name, password: password, handler)
//        }
    }
    
    private func signInUser(name: String, password: String, _ handler: @escaping () -> Void) {
        let email = convertNameToEmail(name)
        Auth.auth().signIn(withEmail: email, password: password) { (res , err) in
            if (err != nil) {
                let errorStr = self.errHandler.handleAuthError(error: err)
                handler()
                self.loginVC?.showError(error: errorStr)
                print(err)
                return
            }
            if (res != nil) {
                let ref = (UIApplication.shared.delegate as? AppDelegate)?.ref
                guard let uid = res?.user.uid  else { return }
                ref?.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let name = value?["name"] as? String
                    let password = value?["password"] as? String
                    let imageUrl = value?["imageUrl"] as? String ?? ""
                    self.saveUser(email: name!, password: password!, imageUrl: imageUrl, handler)
                })
            }
        }
    }
    
    private func saveUser(email: String, password: String, imageUrl: String, _ handler: @escaping () -> Void) {
        let name = convertEmailToName(email)
        if (self.user == nil) {
            self.user = User(name: name, password: password, imageUrl: imageUrl)
        } else {
            self.user?.name = name
            self.user?.password = password
            self.user?.imageUrl = imageUrl
        }
        let rep = AuthRepository.shared
        rep.saveUser(name: name, password: password, imageUrl: imageUrl)
        notification = rep.dbRef?.objects(User.self).observe { (changes) in
            switch changes {
            case .initial:
                break
            case .update(let results, let deletions, let insertions, let modifications):
                if (insertions.count == 1) {
                    handler()
                    self.loginVC?.successLogin()
                }
            case .error(let error):
                print ("error")
                fatalError("\(error)")
            }
        }
    }
    
    func handleSignUpClick() {
        loginVC?.openSignUp()
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
