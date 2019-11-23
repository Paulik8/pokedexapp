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
    
    @objc dynamic var chainId: Int = 0
    let stats = List<PokemonStats>()
    
    convenience init(dict: List<PokemonStats>) {
        self.init()
        for el in dict {
            stats.append(el)
        }
    }
    
}

