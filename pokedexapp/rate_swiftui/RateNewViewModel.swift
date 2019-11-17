//
//  RateViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 16.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift
import Combine

class RateNewViewModel: ObservableObject {
    
//    let didChange = PassthroughSubject<RateNewViewModel, Never>()
    let didChange = ObservableObjectPublisher()
    var notification: NotificationToken?
    let app = (UIApplication.shared).delegate as? AppDelegate
    var id: Int? {
        didSet {
            startObserve()
        }
    }
    var pokemonStats: PokemonStats? {
        didSet {
            self.name = (self.pokemonStats?.stats[0].stat!.name)!
        }
    }
    @Published var name: String = ""
//    {
//        willSet {
//            didChange.send()
//        }
//    }
//    {
//        didSet {
//            didChange.send(self)
//        }
//    }
    
//    init() {
//        startObserve()
//    }
    
    func startObserve() {
        let dbRef = app?.realm
        print ("startObserve", dbRef?.objects(PokemonStats.self))
        notification = dbRef?.objects(PokemonStats.self).observe({ (changes) in
            switch changes {
            case .initial:
                guard let id = self.id else { return }
                self.pokemonStats = self.app?.realm?.objects(PokemonStats.self).filter("pokeId = \(id)").first
                print ("startObserveInitial")
            case .update(let results, let deletions, let insertions, let modifications):
//                self.pokemonStats = self.app?.realm?.objects(PokemonStats.self).filter("id = \(id)").first
                print ("startObserveUpdate")
            case .error:
                break
            }
        })
    }
    
    func removeObservable() {
        notification?.invalidate()
    }
    
}
