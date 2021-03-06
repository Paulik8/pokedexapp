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
    
    let imageUrl: String = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/"
    let didChange = PassthroughSubject<RateNewViewModel, Never>()
    var notification: NotificationToken?
    let app = (UIApplication.shared).delegate as? AppDelegate
    var id: Int?
    var chainId: Int? {
        didSet {
            startObserve()
        }
    }
    @Published var pokemonStats: PokemonStats?
    @Published var stats = [StatData]()
    @Published var stats2 = [StatData]()
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
        let dbRef = app?.realm
        notification = dbRef?.objects(ChainData.self).filter("chainId = \(chainId!)").observe({ (changes) in
            switch changes {
            case .initial:
                guard let id = self.chainId else { return }
                guard let chainData = self.app?.realm?.objects(ChainData.self).filter("chainId = \(id)").first else { return }
                self.pokemonStats = chainData.stats[self.id!]
                self.name = self.imageUrl + self.pokemonStats!.nationalNumber + ".png"
                self.numberOfPages = chainData.stats.count
                self.untieChain(data: chainData)
            case .update(let results, let deletions, let insertions, let modifications):
                break
//                self.pokemonStats = self.app?.realm?.objects(PokemonStats.self).filter("id = \(id)").first
            case .error:
                break
            }
        })
    }
    
    private func untieChain(data chain: ChainData) {
        let statsItem = chain.stats[id!]
        var arr = [StatData]()
        for el in statsItem.stats {
            arr.append(el)
        }
        stats = arr
    }
    
    func removeObservable() {
        notification?.invalidate()
    }
    
}
