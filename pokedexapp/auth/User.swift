//
//  User.swift
//  pokedexapp
//
//  Created by Paulik on 01/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var imageUrl: String = ""
    
    convenience init(name: String, password: String, imageUrl: String) {
        self.init()
        self.name = name
        self.password = password
        self.imageUrl = imageUrl
    }
}
