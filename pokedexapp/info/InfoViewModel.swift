//
//  InfoViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 18/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class InfoViewModel: Notifier {
    
    let imageUrl: String = "https://img.pokemondb.net/artwork/"
    
    var subscriber: SubscriberDelegate?
    var service = Service()
    var pokemonInfo: PokemonInfo? {
        didSet {
            subscriber!.notify()
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
    
    //start Notifier
    
    func notifyData(_ data: Any?) {
        pokemonInfo = data as? PokemonInfo
    }
    
    //end
    
}
