//
//  InfoViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 18/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import RealmSwift

class InfoViewModel: Notifier {
    
    let imageUrl: String = "https://img.pokemondb.net/artwork/"
    let dbRef = ((UIApplication.shared.delegate) as? AppDelegate)?.realm
    var subscriber: SubscriberDelegate?
    var service = Service()
    var pokemonInfo: PokemonInfo? {
        didSet {
            self.subscriber!.notify()
            self.savePokemonStats()
        }
    }
    var poster = UIImageView()
    
    init() {
        service.viewModel = self
    }
    
    func createRequest(name: String) {
        service.getInfoPokemon(name: name)
        poster.loadImageFromUrl(imageUrl + name +  ".jpg")  {
            self.subscriber?.notify()
        }
    }
    
    private func savePokemonStats() {
        DispatchQueue.main.async {
            guard let info = self.pokemonInfo else { return }
            var convertedStats = List<StatData>() //CONVERTER
            for stat in info.stats {
                convertedStats.append(StatData(baseStat: stat.baseStat, effort: stat.effort, stat: SpeciesData(name: stat.stat.name, url: stat.stat.url)))
            } //CONVERTER
            let stats = PokemonStats(stats: convertedStats)
            stats.pokeId = info.id
            
            try! self.dbRef?.write {
                self.dbRef?.add(stats)
            }
        }
    }
    
    //start Notifier
    
    func notifyData(_ data: Any?) {
        pokemonInfo = data as? PokemonInfo
    }
    
    //end
    
}
