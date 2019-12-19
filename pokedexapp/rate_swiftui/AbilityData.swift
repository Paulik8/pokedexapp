//
//  AbilityData.swift
//  pokedexapp
//
//  Created by Paulik on 20.12.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class AbilityData: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var descriptionName: String = ""
    
    convenience init(name: String, url: String, descriptionName: String) {
        self.init()
        self.name = name
        self.url = url
        self.descriptionName = descriptionName
    }
    
}

