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
        let convertedAbilities = List<AbilityData>()
        for ability in infoPokemon.abilities {
            if (!ability.isHidden) {
                convertedAbilities.append(AbilityData(name: ability.ability.name, url: ability.ability.url, descriptionName: ""))
            }
        }
        let stats = PokemonStats(stats: convertedStats, abilities: convertedAbilities)
        stats.pokeId = infoPokemon.id
        stats.nationalNumber = idToNationalNumber(infoPokemon.id)
        stats.height = infoPokemon.height
        stats.weight = infoPokemon.weight
        return stats
    }
    
    private func idToNationalNumber(_ id: Int) -> String {
        if (id > 0 && id < 10) {
            return "00\(id)"
        } else if (id >= 10 && id < 100) {
            return "0\(id)"
        } else {
            return "\(id)"
        }
    }
    
}
