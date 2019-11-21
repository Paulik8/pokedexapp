//
//  MainViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 29/09/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewModel: Notifier {
    
    var mainVC: MainNotifier?
    let converter = MainConverter()
    let repository = MainPokemonRepository.shared
    var pokemonImages = [Int:UIImage]()
    var pokemons: [PokemonData]?
//    {
//        didSet {
//            mainVC!.updateData()
//        }
//    }
    var notification: NotificationToken?
    var service = Service()
    
    init() {
        service.viewModel = self
        service.converter = converter
    }
    
    func createRequest() {
        if let pokemons = repository.getPokemons() {
            self.pokemons = pokemons
            mainVC?.updateData()
        }
        service.getPokemons()
    }
    
    func fetchPokemons(indexOf: Int, isImportant priority: Bool) {
        guard let pokes = pokemons else { return }
        guard let sprites = pokes[indexOf].sprites else { return }
        guard let imageUrl = sprites.large else { return }
        service.fetchWithDataTask(imageUrl, priority) {
            print("keklik", indexOf, priority)
            let image = UIImage(data: $0)
            self.pokemonImages[indexOf] = image
            self.mainVC?.updateRow(row: indexOf)
        }
    }
    
    func cancelFetchPokemons(indexOf: Int) {
        guard let pokes = pokemons else { return }
        guard let sprites = pokes[indexOf].sprites else { return }
        guard let imageUrl = sprites.large else { return }
        service.cancelFetch(imageUrl)
    }
    
    func checkCharsName(name: String) -> String {
        return service.charCheck(name: name)
    }
    
//    func getProfileLogoUrl() -> String? {
//        
//    }
    
    func profileLongTouched() {
        let rep = AuthRepository.shared
        rep.deleteUser()
        notification = rep.dbRef?.objects(User.self).observe({ (changes) in
            switch changes {
            case .initial:
                break
            case .update(let results, let deletions, let insertions, let modifications):
                if (deletions.count == 1) {
                    self.mainVC?.openLogin()
                }
            case .error(let error):
                print ("error")
                fatalError("\(error)")
            }
        })
    }
    
    func profileClicked() {
        mainVC?.openProfile()
    }
    
    func unsubscribe() {
        notification?.invalidate()
    }
    
    //start Notifier
    
    func notifyData(_ data: Any?) {
        pokemons = data as? [PokemonData]
        guard let pokemons = self.pokemons else {
            mainVC?.updateData()
            return
        }
        repository.savePokemons(data: pokemons)
        mainVC?.updateData()
    }
    
    //end
    
}
