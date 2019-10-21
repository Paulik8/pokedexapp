//
//  Pokemon.swift
//  pokedexapp
//
//  Created by Paulik on 03/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    var results: [Result]
}

struct Result: Codable {
    let nationalNumber: String
    let evolution: Evolution?
    var sprites: Images
    var name: String
    let type: [String]
    let total, hp, attack, defense: Int
    let spAtk, spDef, speed: Int
    
    enum CodingKeys: String, CodingKey {
        case nationalNumber = "national_number"
        case evolution, sprites, name, type, total, hp, attack, defense
        case spAtk = "sp_atk"
        case spDef = "sp_def"
        case speed
    }
}

struct Images: Codable {
    let normal: String
    var large: String
    let animated: String
}

struct Evolution: Codable {
    let name: String
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}
