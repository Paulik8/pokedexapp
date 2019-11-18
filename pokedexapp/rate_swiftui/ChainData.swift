//
//  ChainData.swift
//  pokedexapp
//
//  Created by Paulik on 18.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class ChainData: Object {
    
    var chainId: Int = 0
    var pokemonStat: PokemonStats? = PokemonStats()
    
}

