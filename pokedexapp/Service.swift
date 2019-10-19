//
//  Service.swift
//  pokedexapp
//
//  Created by Paulik on 30/09/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation

struct Service {
    
    var viewModel: Notifier?
    
    let listPokemonUrl = "https://raw.githubusercontent.com/joseluisq/pokemons/master/pokemons.json"
    
    let infoPokemonUrl = "https://pokeapi.co/api/v2/pokemon/"
    
    
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
    
    func getInfoPokemon(name: String) {
        guard let url = URL(string: infoPokemonUrl + "\(name)") else { return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
          do {
            guard let data = data else { return }
            let decodedPokemonInfo = try JSONDecoder().decode(PokemonInfo.self, from: data)
            self.viewModel?.notifyData(decodedPokemonInfo)
            }
            catch {
                print(error)
            }
        }.resume()
    }
    
    func getValue() -> String {
        return "Value"
    }
    

}
