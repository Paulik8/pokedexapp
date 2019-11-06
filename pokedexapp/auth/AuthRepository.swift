//
//  AuthRepository.swift
//  pokedexapp
//
//  Created by Paulik on 01/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import CoreData

class AuthRepository {
    
    let entity = "Users"
    private var isProfileLogo = false
    
    static var shared: AuthRepository = {
        let instance = AuthRepository()
        return instance
    }()
    
    func getUser() -> User? {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
        do {
            let results = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            if (results.count == 0) {
                return nil
            }
            let data = results[0]
            var user = User()
            user.name = data.value(forKey: "name") as? String
            user.password = data.value(forKey: "password") as? String
            user.imageUrl = data.value(forKey: "imageUrl") as? String
            return user
        } catch {
            print ("request failed")
            return nil
        }
        
    }
    
    func saveUser(name: String, password: String, imageUrl: String) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let entityToSave = NSEntityDescription.entity(forEntityName: entity, in: context)
        let newUser = NSManagedObject(entity: entityToSave!, insertInto: context)
        
        newUser.setValue(name, forKey: "name")
        newUser.setValue(password, forKey: "password")
        newUser.setValue(imageUrl, forKey: "imageUrl")
        
        do {
            try context.save()
        } catch {
            print ("save failed")
        }
    }
    
    func deleteUser() {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            _ = try managedObjectContext.execute(request)
        } catch {
            print ("delete failed")
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
