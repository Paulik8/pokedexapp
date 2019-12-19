//
//  PokemonChain.swift
//  dev
//
//  Created by Paulik on 15/09/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - PokemonChain
struct PokemonChain: Codable {
    let babyTriggerItem: ChainSpecies?
    let chain: Chain
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case babyTriggerItem = "baby_trigger_item"
        case chain, id
    }
}

// MARK: - Chain
struct Chain: Codable {
    let evolutionDetails: [EvolutionDetail]?
    let evolvesTo: [Chain]?
    let isBaby: Bool
    let species: ChainSpecies
    
    enum CodingKeys: String, CodingKey {
        case evolutionDetails = "evolution_details"
        case evolvesTo = "evolves_to"
        case isBaby = "is_baby"
        case species
    }
}

// MARK: - EvolutionDetail
struct EvolutionDetail: Codable {
    let gender, heldItem: JSONNull?
    let item: Species?
    let knownMove, knownMoveType: ChainSpecies?
    let location: ChainSpecies?
    let minAffection, minBeauty: Int?
    let minHappiness: Int?
    let minLevel: Int?
    let needsOverworldRain: Bool?
    let partySpecies, partyType, relativePhysicalStats: ChainSpecies?
    let timeOfDay: String?
    let tradeSpecies: JSONNull?
    let trigger: ChainSpecies?
    let turnUpsideDown: Bool?
    
    enum CodingKeys: String, CodingKey {
        case gender
        case heldItem = "held_item"
        case item
        case knownMove = "known_move"
        case knownMoveType = "known_move_type"
        case location
        case minAffection = "min_affection"
        case minBeauty = "min_beauty"
        case minHappiness = "min_happiness"
        case minLevel = "min_level"
        case needsOverworldRain = "needs_overworld_rain"
        case partySpecies = "party_species"
        case partyType = "party_type"
        case relativePhysicalStats = "relative_physical_stats"
        case timeOfDay = "time_of_day"
        case tradeSpecies = "trade_species"
        case trigger
        case turnUpsideDown = "turn_upside_down"
    }
}

// MARK: - Species
struct ChainSpecies: Codable {
    let name: String
    let url: String
}

