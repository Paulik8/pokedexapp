//
//  MainViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 29/09/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class MainViewModel: Notifier {
    
    var subscriber: SubscriberDelegate?
    var pokemons: Pokemon? {
        didSet {
            subscriber!.notify()
        }
    }
    var service = Service()
    
    init() {
        service.viewModel = self
    }
    
    func createRequest() {
        service.getPokemons()
    }
    
    
    //start Notifier
    
    func notifyData(_ data: Any?) {
        pokemons = data as? Pokemon
    }
    
    //end
 
    
}
