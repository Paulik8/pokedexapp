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
    
    static var shared: AuthRepository = {
        let instance = AuthRepository()
        return instance
    }()
    
    func getUser() -> User? {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Users")
        do {
            let results = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            if (results.count == 0) {
                return nil
            }
            let data = results[0]
            var user = User()
            user.name = data.value(forKey: "name") as? String
            user.password = data.value(forKey: "password") as? String
            return user
        } catch {
            print ("request failed")
            return nil
        }
        
    }
    
    func saveUser(name: String, password: String) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue(name, forKey: "name")
        newUser.setValue(password, forKey: "password")
        
        do {
            try context.save()
        } catch {
            print ("save failed")
        }
    }
    
}
