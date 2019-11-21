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
    var converter: Converter?
    var dataTasks = [URLSessionDataTask]()
    
    let listPokemonUrl = "https://raw.githubusercontent.com/joseluisq/pokemons/master/pokemons.json"
    let infoPokemonUrl = "https://pokeapi.co/api/v2/pokemon/"
    let imageUrl: String = "https://img.pokemondb.net/artwork/"
    let pictureExtension = ".jpg"
    
    
    func fetchWithDataTask(_ urlStr: String, _ isImportant: Bool, handler: @escaping (Data) -> Void) {
        if let _ = checkDataInQueue(urlStr) {
            return
        } else {
            guard let url = URL(string: urlStr) else { return }
            let dataTask = URLSession.shared.dataTask(with: url) { (data, res, err) in
                if err != nil { return }
                guard let image = data else { return }
                DispatchQueue.main.async {
                    handler(image)
                }
            }
            dataTask.resume()
            if (isImportant) {
                dataTask.priority = URLSessionDataTask.highPriority
            } else {
                dataTask.priority = URLSessionDataTask.lowPriority
            }
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
            let converter = InfoConverter()
            let convertedPokemonInfo = converter.convert(infoPokemon: decodedPokemonInfo)
            self.viewModel?.notifyData(convertedPokemonInfo)
            }
            catch {
                print(error)
            }
        }.resume()
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
