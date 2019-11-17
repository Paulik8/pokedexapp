//
//  SpeciesData.swift
//  pokedexapp
//
//  Created by Paulik on 17.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class SpeciesData: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    
    convenience init(name: String, url: String) {
        self.init()
        self.name = name
        self.url = url
    }
    
}
