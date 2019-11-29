//
//  Service.swift
//  pokedexapp
//
//  Created by Paulik on 30/09/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class NetworkService {
    
    var viewModel: Notifier?
    var infoViewModel: InfoNotifier?
    var chainNotifier: ChainNotifier?
    var converter: Converter?
    let infoConverter = InfoConverter()
    var dataTasks = [URLSessionDataTask]()
    
    let listPokemonUrl = "https://raw.githubusercontent.com/joseluisq/pokemons/master/pokemons.json"
    let infoPokemonUrl = "https://pokeapi.co/api/v2/pokemon/"
    let speciesPokemonUrl = "https://pokeapi.co/api/v2/pokemon-species/"
    let imageUrl: String = "https://img.pokemondb.net/artwork/"
    let pictureExtension = ".jpg"
    
    
    func fetchWithDataTask(_ urlStr: String, _ isImportant: Bool, _ handler: @escaping (UIImage) -> Void) {
        if let _ = checkDataInQueue(urlStr) {
            return
        } else {
            guard let url = URL(string: urlStr) else { return }
            let dataTask = URLSession.shared.dataTask(with: url) { (data, res, err) in
                if err != nil { return }
                guard let image = data else { return }
                guard let decodedImage = UIImage(data: image) else { return }
                DispatchQueue.main.async {
                    handler(decodedImage)
                }
            }
            if (isImportant) {
                dataTask.priority = URLSessionDataTask.highPriority
            } else {
                dataTask.priority = URLSessionDataTask.lowPriority
            }
            dataTask.resume()
            dataTasks.append(dataTask)
        }
    }
    
    func cancelFetch(_ urlStr: String) {
        guard let index = checkDataInQueue(urlStr) else { return }
        let task = dataTasks[index]
        task.cancel()
        dataTasks.remove(at: index)
    }
    
    private func checkDataInQueue(_ urlStr: String) -> Int? {
        guard
            let url = URL(string: urlStr),
            let dataTaskIndex = dataTasks.firstIndex(where: { task in
                task.originalRequest?.url == url
            }) else {
                return nil
        }
        return dataTaskIndex
    }
    
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
                for (index, poke) in pokemons.results.enumerated() {
                    pokemons.results[index].sprites.large = self.converter!.convert(name: poke.name.lowercased())
                }
                let dataConverter = MainPokemonConverter()
                let convertedPoke = dataConverter.convert(pokemons: pokemons)
                self.viewModel!.notifyData(convertedPoke)
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
            let convertedPokemonInfo = self.infoConverter.convert(infoPokemon: decodedPokemonInfo)
            self.infoViewModel?.notifyData(data: convertedPokemonInfo)
            }
            catch {
                print(error)
            }
        }.resume()
    }
    
    func loadEvolutionUrl(pokemonId id: Int) {
        guard let url = URL(string: speciesPokemonUrl + "\(id)") else {
            return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            do {
                guard let data = data else { return }
                let decodedData = try newJSONDecoder().decode(PokemonSpecies.self, from: data)
                self.loadEvolutionChain(decodedData.evolutionChain.url)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    private func loadEvolutionChain(_ evolutionChainUrl: String) {
        guard let url = URL(string: evolutionChainUrl) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, res, err) in
            if err != nil { return }
            guard let data = data else { return }
            do {
                let dec = try newJSONDecoder().decode(PokemonChain.self, from: data)
                self.chainNotifier?.setChainId(id: dec.id!)
                self.chainNotifier?.chainResolved(chain: dec.chain)
            } catch {
                print (error)
            }
        }).resume()
    }
    
    func loadPokemonInfoFromIntermediateArray(url: URL, _ handler: @escaping (PokemonStats) -> Void) {
        let group = DispatchGroup()
        group.enter()
        URLSession.shared.dataTask(with: url, completionHandler: { (data, res, err) in
            guard let data = data else { return }
            guard let decodedData = try? newJSONDecoder().decode(PokemonInfo.self, from: data) else { return }
            let convertedPokemonInfo = self.infoConverter.convert(infoPokemon: decodedData)
            handler(convertedPokemonInfo)
            group.leave()
        }).resume()
    }
     
    func charCheck(name str: String) -> String {
        var changedStr: String = imageUrl
        for el in str.unicodeScalars {
            if (el.value >= 65 && el.value <= 90) || (el.value >= 97 && el.value <= 122) {
                changedStr.append(String(el))
            }
            if (el.value == 9792) {
                changedStr.append("-f")
            }
            if (el.value == 9794) {
                changedStr.append("-m")
            }
        }
        changedStr += pictureExtension
        return changedStr
    }
    

}
