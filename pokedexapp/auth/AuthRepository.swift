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
    
    func getUser() {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let predicate = NSPredicate(format: "name == %@ and password == %@", user)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
//        fetchRequest.predicate = predicate
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            for data in results as! [NSManagedObject] {
                print (data.value(forKey: "name") as! String)
            }
        } catch {
            print ("request failed")
        }
    }
    
    func saveUser(name: String, password: String) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
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
