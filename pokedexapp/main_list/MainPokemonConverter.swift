//
//  MainPokemonConverter.swift
//  pokedexapp
//
//  Created by Paulik on 21.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class MainPokemonConverter {
    
    func convert(pokemons: Pokemon) -> [PokemonData] {
        var arr = [PokemonData]()
        for el in pokemons.results {
            let arrTypes = List<String>()
            for type in el.type {
                arrTypes.append(type)
            }
            let data = PokemonData(types: arrTypes)
            data.nationalNumber = el.nationalNumber
            data.name = el.name
            data.sprites = ImagesData(el.sprites.normal, el.sprites.large, el.sprites.animated)
            arr.append(data)
        }
        return arr
    }
    
}
