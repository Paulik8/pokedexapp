//
//  InfoConverter.swift
//  pokedexapp
//
//  Created by Paulik on 22.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class InfoConverter {
    
    func convert(infoPokemon: PokemonInfo) -> PokemonStats {
        let convertedStats = List<StatData>() //CONVERTER
        for stat in infoPokemon.stats {
            convertedStats.append(StatData(baseStat: stat.baseStat, effort: stat.effort, stat: SpeciesData(name: stat.stat.name, url: stat.stat.url)))
        } //CONVERTER
        let stats = PokemonStats(stats: convertedStats)
        stats.pokeId = infoPokemon.id
        stats.height = infoPokemon.height
        stats.weight = infoPokemon.weight
        return stats
    }
    
}
