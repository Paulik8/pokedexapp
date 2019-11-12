//
//  ToDoItem.swift
//  pokedexapp
//
//  Created by Paulik on 12/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var id = ""
    @objc dynamic var text = ""
    @objc dynamic var isCompleted = false
    
//    init(id: String, ) {
//        <#statements#>
//    }
    
}

extension ToDoItem {
    static func all(in realm: Realm = try! Realm()) -> Results<ToDoItem> {
      return realm.objects(ToDoItem.self)
    }
}
