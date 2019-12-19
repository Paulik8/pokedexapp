//
//  RateViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 13/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class RateViewModel {
    
    let speciesUrl = "https://pokeapi.co/api/v2/pokemon-species/"
    var pokemonId: Int?
    var speciesArray: [ChainSpecies] = [] {
        didSet {
            rateVC?.speciesArrayUpdated()
        }
    }
//    {
//        didSet {
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//                self.loadEvolutionPokemons()
//                self.updatePageControlNumber()
//            }
//        }
//    }
    var rateVC: RateNotifier?
    
    func loadEvolution() {
        guard let id = pokemonId else { return }
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(id)") else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, res, err) in
            if err != nil { return }
            guard let data = data else { return }
            do {
                let decodedData = try newJSONDecoder().decode(PokemonSpecies.self, from: data)
                self.loadEvolutionChain(decodedData.evolutionChain.url)
            } catch {
                print (error)
            }
            
        }).resume()
    }
    
    private func loadEvolutionChain(_ evolutionChainUrl: String) {
            guard let url = URL(string: evolutionChainUrl) else { return }
            URLSession.shared.dataTask(with: url, completionHandler: { (data, res, err) in
                if err != nil { return }
                guard let data = data else { return }
                do {
                    let dec = try newJSONDecoder().decode(PokemonChain.self, from: data)
                    self.solveChain(dec.chain)
                } catch {
                    print (error)
                }
            }).resume()
        }
    
    func solveChain(_ chain: Chain) {
        var arr = [ChainSpecies]()
        arr.append(chain.species)
        guard var next = chain.evolvesTo else {
            speciesArray = arr
//            fillNavBarArr()
            return
        }
        while (next.count != 0) {
            arr.append(next[0].species)
            guard let nextStep = next[0].evolvesTo else {
                speciesArray = arr
                return
            }
            next = nextStep
        }
        speciesArray = arr
    }
    
}
