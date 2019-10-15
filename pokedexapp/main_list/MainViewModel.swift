//
//  MainViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 29/09/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class MainViewModel: Notifier {
    
    var delegate: SubscriberDelegate?
    var pokemons: Pokemon? {
        didSet {
            delegate!.notify()
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
    
    func notifyData(_ data: Pokemon?) {
        pokemons = data
    }
    
    //end
 
    
}
