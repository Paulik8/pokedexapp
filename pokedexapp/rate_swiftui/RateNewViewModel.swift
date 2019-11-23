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
    
    let imageUrl: String = "https://img.pokemondb.net/artwork/"
    let didChange = PassthroughSubject<RateNewViewModel, Never>()
    var notification: NotificationToken?
    let app = (UIApplication.shared).delegate as? AppDelegate
    var id: Int? {
        didSet {
            startObserve()
        }
    }
    @Published var pokemonStats: PokemonStats?
//    {
//        didSet {
//            self.numberOfPages = 3
//            self.capsuleHeight = pokemonStats!.height
//            self.name = imageUrl + "bulbasaur.jpg"
//        }
//    }
    @Published var stats = [StatData]()
    @Published var name: String = ""
    @Published var numberOfPages: Int = 0
    var capsuleHeight: Int = 0 {
        didSet {
            didChange.send(self)
        }
    }
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
        self.falseUntieChain()
        let dbRef = app?.realm
        notification = dbRef?.objects(ChainData.self).filter("chainId = \(id!)").observe({ (changes) in
            switch changes {
            case .initial:
                guard let id = self.id else { return }
                guard let chainData = self.app?.realm?.objects(ChainData.self).filter("chainId = \(id)").first else { return }
                self.pokemonStats = chainData.stats.first!
                self.numberOfPages = chainData.stats.count
                self.untieChain(data: chainData)
                print ("startObserveInitial")
            case .update(let results, let deletions, let insertions, let modifications):
//                self.pokemonStats = self.app?.realm?.objects(PokemonStats.self).filter("id = \(id)").first
                print ("startObserveUpdate")
            case .error:
                break
            }
        })
    }
    
    private func falseUntieChain() {
        var arr = [StatData]()
        for _ in (0..<2) {
            arr.append(StatData(baseStat: 0, effort: 0, stat: SpeciesData(name: "", url: "")))
        }
        stats = arr
    }
    
    private func untieChain(data chain: ChainData) {
        guard let statsItem = chain.stats.first else { return }
        var arr = [StatData]()
        for el in statsItem.stats {
            arr.append(el)
        }
        stats = arr
//        for el in statsItem.stats {
//
//        }
    }
    
    func removeObservable() {
        notification?.invalidate()
    }
    
}
