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
    
    @objc dynamic var pokeId: Int = 0
//    var id: Int { self.pokeId }
    let stats = List<StatData>()
    
    convenience init(stats: List<StatData>) {
        self.init()
        for stat in  stats {
            self.stats.append(stat)
        }
    }
    
}
