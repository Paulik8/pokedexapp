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
    let abilities = List<AbilityData>()
    
    convenience init(stats: List<StatData>, abilities: List<AbilityData>) {
        self.init()
        for stat in stats {
            self.stats.append(stat)
        }
        for ability in abilities {
            self.abilities.append(ability)
        }
    }
    
    override class func primaryKey() -> String? {
        return "pokemonStatsId"
    }
    
}


