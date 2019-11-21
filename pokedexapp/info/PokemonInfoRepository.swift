//
//  PokemonInfoRepository.swift
//  pokedexapp
//
//  Created by Paulik on 22.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class PokemonInfoRepository {
    
    let dbRef = (UIApplication.shared.delegate as? AppDelegate)?.realm
    
    static var shared: PokemonInfoRepository = {
        let shared = PokemonInfoRepository()
        return shared
    }()
    
    func getPokemonInfo(byId id: Int) -> PokemonStats? {
        guard let info = dbRef?.objects(PokemonStats.self).filter("pokeId = \(id)").first else { return nil }
        return info
    }
    
    func savePokemonInfo(data: PokemonStats) {
        DispatchQueue.main.async {
            if let dbObject = self.dbRef?.objects(PokemonStats.self).filter("pokeId = \(data.pokeId)").first {
                try! self.dbRef?.write {
                    self.dbRef?.delete(dbObject)
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
