//
//  PokemonData.swift
//  pokedexapp
//
//  Created by Paulik on 21.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class PokemonData: Object {
    @objc dynamic var nationalNumber: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var sprites: ImagesData?
    let type = List<String>()
    
    convenience init(types: List<String>) {
        self.init()
        for el in types {
            self.type.append(el)
        }
    }
    
}

class ImagesData: Object {
    @objc dynamic var normal: String?
    @objc dynamic var large: String?
    @objc dynamic var animated: String?
    
    convenience init(_ normal: String, _ large: String, _ animated: String) {
        self.init()
        self.normal = normal
        self.large = large
        self.animated = animated
    }
}
