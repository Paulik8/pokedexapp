//
//  DictionaryChain.swift
//  pokedexapp
//
//  Created by Paulik on 22.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class DictionaryChain: Object {
    
    var id: Int?
    var pokemonStat: PokemonStats? = PokemonStats()
    
}
