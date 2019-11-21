//
//  MainPokemonRepository.swift
//  pokedexapp
//
//  Created by Paulik on 21.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class MainPokemonRepository {
    
    let dbRef = (UIApplication.shared.delegate as? AppDelegate)?.realm
    
    static var shared: MainPokemonRepository = {
        let shared = MainPokemonRepository()
        return shared
    }()
    
    func getPokemons() -> [PokemonData]? {
        guard let pokemons = dbRef?.objects(PokemonData.self) else { return nil }
        var arr = [PokemonData]()
        for el in pokemons {
            arr.append(el)
        }
        return arr
    }
    
    func savePokemons(data: [PokemonData]) {
        DispatchQueue.main.async {
            if let dbObjects = self.dbRef?.objects(PokemonData.self) {
                try! self.dbRef?.write {
                    self.dbRef?.delete(dbObjects)
                    self.dbRef?.add(data)
                }
            } else {
                try! self.dbRef?.write {
                self.dbRef?.add(data)
                }
            }
        }
    }
    
}
