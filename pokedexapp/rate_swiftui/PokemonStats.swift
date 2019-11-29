//
//  PokemonStats.swift
//  pokedexapp
//
//  Created by Paulik on 17.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class PokemonStats: Object {
    @objc dynamic var pokemonStatsId: String = UUID().uuidString
    @objc dynamic var pokeId: Int = 0
    @objc dynamic var nationalNumber: String = ""
    @objc dynamic var height: Int = 0
    @objc dynamic var weight: Int = 0
    let stats = List<StatData>()
    
    convenience init(stats: List<StatData>) {
        self.init()
        for stat in stats {
            self.stats.append(stat)
        }
    }
    
    override class func primaryKey() -> String? {
        return "pokemonStatsId"
    }
    
}


