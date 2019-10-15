//
//  Service.swift
//  pokedexapp
//
//  Created by Paulik on 30/09/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation

class Service {
    
    var viewModel: Notifier?
    
    let listPokemonUrl = "https://raw.githubusercontent.com/joseluisq/pokemons/master/pokemons.json"
    
    
    func getPokemons() {
        var result: Pokemon?
        guard let url = URL(string: listPokemonUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            do {
                guard let data = data else { return }
                result = try JSONDecoder().decode(Pokemon.self, from: data)
                guard var pokemons = result else { return }
                pokemons.results = pokemons.results.getUniquePokemons {
                    $0.name
                }
                self.viewModel!.notifyData(pokemons)
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func getValue() -> String {
        return "Value"
    }
    

}
