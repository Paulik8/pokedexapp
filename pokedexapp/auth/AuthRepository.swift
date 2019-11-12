//
//  AuthRepository.swift
//  pokedexapp
//
//  Created by Paulik on 01/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class AuthRepository {
    
    let entity = "Users"
    let dbRef = (UIApplication.shared.delegate as? AppDelegate)?.realm
    private var isProfileLogo = false
    var users: User?
    
    static var shared: AuthRepository = {
        let instance = AuthRepository()
        return instance
    }()
    
    func getUser() -> User? {
        return dbRef?.objects(User.self).first
    }
    
    func saveUser(name: String, password: String, imageUrl: String) {
        let newUser = User()
        newUser.name = name
        newUser.password = password
        newUser.imageUrl = imageUrl
        DispatchQueue.main.async {
            try! self.dbRef?.write {
                self.dbRef?.add(newUser)
            }
        }
    }
    
    func deleteUser() {
        guard let userObject = dbRef?.objects(User.self) else { return }
        DispatchQueue.main.async {
            try? self.dbRef?.write {
                self.dbRef?.delete(userObject)
            }
        }
        
    }
    
    func changeProfileLogo() {
        
    }
    
    func getProfileLogoStatus() -> Bool {
        return isProfileLogo
    }
    
    func setProfileLogoStatus(status: Bool) {
        isProfileLogo = status
    }
    
}
