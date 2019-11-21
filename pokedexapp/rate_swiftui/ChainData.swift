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
    let dictionaryChain = List<DictionaryChain>()
    
    convenience init(dict: List<DictionaryChain>) {
        self.init()
        for el in dict {
            dictionaryChain.append(el)
        }
    }
    
}

