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
    var converter = MainConverter()
    
    init() {
        service.viewModel = self
        service.converter = converter
    }
    
    func createRequest() {
        service.getPokemons()
    }
    
    func checkCharsName(name: String) -> String {
        return service.charCheck(name: name)
    }
    
    //start Notifier
    
    func notifyData(_ data: Any?) {
        pokemons = data as? Pokemon
    }
    
    //end
 
    
}
