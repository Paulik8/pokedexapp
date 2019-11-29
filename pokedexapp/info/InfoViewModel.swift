//
//  InfoViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 18/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import RealmSwift

class InfoViewModel {
    
//    let imageUrl: String = "https://img.pokemondb.net/artwork/"
    let imageUrl: String = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/"
    let dbRef = ((UIApplication.shared.delegate) as? AppDelegate)?.realm
    let repository = PokemonInfoRepository.shared
    var subscriber: SubscriberDelegate?
    var service = NetworkService()
    
    var pokemonName: String?
    var idForImage: String?
    var pokemonId: Int?
    {
        didSet {
            self.loadEvolution()
        }
    }
    var pokemonInfo: PokemonStats?
    var speciesChainIntermediateArr: [ChainSpecies]? {
        didSet {
            self.loadPokemonInfoFromIntermediateArray()
        }
    }
    var pokemonChain: [Int:PokemonStats] = [:] {
        didSet {
            guard let arr = speciesChainIntermediateArr else { return }
            if (pokemonChain.count == arr.count) {
                self.saveChainData()
            }
        }
    }
    var poster = UIImageView()
    var chainId: Int?
    
    init() {
        service.infoViewModel = self
        service.chainNotifier = self
    }
    
    func createRequest(name: String, id: Int) {
        if let dbObject = repository.getPokemonInfo(byId: id) {
            self.pokemonInfo = dbObject
            asyncUpdate {
                self.subscriber?.notify()
            }
        }
        service.getInfoPokemon(name: name)
        guard let imageId = idForImage else { return }
        poster.loadImagePng(imageUrl, imageId) {
            print("keklik", self.poster.image)
            self.subscriber?.notify()
        }
    }
    
    func loadEvolution() {
        service.loadEvolutionUrl(pokemonId: pokemonId!)
    }
    
    func getChainData() -> Int? {
        guard let chainId = self.chainId else { return nil }
        guard let chainData = repository.getChainData(chainId: chainId) else { return nil }
        return chainData.stats.count
    }
    
    private func saveChainData() {
        let size = pokemonChain.count
        var iterations = 0
        let list = List<PokemonStats>()
        while (iterations < size) {
            guard let stat = pokemonChain[iterations] else { return }
            list.append(stat)
            iterations += 1
        }
        let chainData = ChainData(dict: list)
        chainData.chainId = self.chainId!
        repository.savePokemonChain(chain: chainData)
    }
    
    private func loadPokemonInfoFromIntermediateArray() {
        guard let arr = speciesChainIntermediateArr else { return }
        for (index, el) in arr.enumerated() {
            guard let id = parseIdFromUrl(url: el.url) else { break }
            guard let url = getPokemonInfoUlr(id: id) else { break }
            service.loadPokemonInfoFromIntermediateArray(url: url) {
                self.pokemonChain.updateValue($0, forKey: index)
            }
        }
    }
    
    private func updateChainData() {
        
    }
    
    private func parseIdFromUrl(url: String) -> Int? {
        let splitted = url.split(separator: "/")
        let splittedStr = String(splitted[splitted.count - 1])
        return Int(splittedStr) ?? nil
    }
    
    private func getPokemonInfoUlr(id: Int) -> URL? {
        return URL(string: service.infoPokemonUrl + String(id)) ?? nil
    }
    
    private func solveChain(chain: Chain) {
        var arr = [ChainSpecies]()
        arr.append(chain.species)
        guard var next = chain.evolvesTo else {
            speciesChainIntermediateArr = arr
            return
        }
        while (next.count != 0) {
            arr.append(next[0].species)
            guard let nextStep = next[0].evolvesTo else {
                speciesChainIntermediateArr = arr
                return
            }
            next = nextStep
        }
        speciesChainIntermediateArr = arr
    }
    
    private func asyncUpdate(update: @escaping () -> Void) {
        DispatchQueue.main.async {
            update()
        }
    }
    
}

extension InfoViewModel: InfoNotifier, ChainNotifier {
    
    //start ChainNotifier
    
    func chainResolved(chain: Chain) {
        solveChain(chain: chain)
    }
    
    func setChainId(id: Int) {
        chainId = id
    }
    
    //end ChainNotifier
    
    //start Notifier
    
    func notifyData(data: PokemonStats) {
        pokemonInfo = data
        guard let info = self.pokemonInfo else {
            subscriber?.notify()
            return
        }
        repository.savePokemonInfo(data: info)
        asyncUpdate {
            self.subscriber?.notify()
        }
    }
    
    //end
    
}
