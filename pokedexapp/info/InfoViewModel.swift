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
    let repository = PokemonInfoRepository.shared
    var subscriber: SubscriberDelegate?
    var service = Service()
    var pokemonInfo: PokemonStats?
    var pokemonChain: [Int:PokemonStats]?
//    {
//        didSet {
//            
//        }
//    }
    var poster = UIImageView()
    
    init() {
        service.viewModel = self
    }
    
    func createRequest(name: String, id: Int) {
        if let dbObject = repository.getPokemonInfo(byId: id) {
            self.pokemonInfo = dbObject
            subscriber?.notify()
        }
        service.getInfoPokemon(name: name)
        poster.loadImageFromUrl(imageUrl + name +  ".jpg")  {
            self.subscriber?.notify()
        }
    }
    
    func loadEvolution() {
        
    }
    
    //start Notifier
    
    func notifyData(_ data: Any?) {
        pokemonInfo = data as? PokemonStats
        guard let info = self.pokemonInfo else {
            subscriber?.notify()
            return
        }
        repository.savePokemonInfo(data: info)
        subscriber?.notify()
    }
    
    //end
    
}
