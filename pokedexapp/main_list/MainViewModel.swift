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
    
    let images: String = "https://assets.pokemon.com/assets/cms2/img/pokedex/detail/"
    let extensionImages = ".png"
    
    var mainVC: MainNotifier?
    let converter = MainConverter()
    let repository = MainPokemonRepository.shared
    var pokemonImages = [String : UIImage]()
    var pokemons: [PokemonData]?
    var filteredPokemons = [PokemonData]()
    let cacheManager = CacheManager.shared
//    {
//        didSet {
//            mainVC!.updateData()
//        }
//    }
    var notification: NotificationToken?
    var service = NetworkService()
    
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
    
    func fetchPokemons(indexOf: Int, isImportant priority: Bool, _ isFiltered: Bool?, _ completion: @escaping () -> Void) {
        guard let pokes = pokemons else { return }
        let nationalNumber: String
        if let filtered = isFiltered {
            if (filtered) {
                nationalNumber = filteredPokemons[indexOf].nationalNumber
            } else {
                nationalNumber = pokes[indexOf].nationalNumber
            }
        } else {
            nationalNumber = pokes[indexOf].nationalNumber
        }
        let imageUrl = images + nationalNumber + extensionImages
        service.fetchWithDataTask(imageUrl, priority) {
            self.cacheManager.cacheImage(id: nationalNumber, data: $0)
            self.pokemonImages[nationalNumber] = $0
            completion()
//            self.mainVC?.updateRow(row: indexOf)
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
    
    func filteredDataForSearch(_ searchText: String) {
        guard let loadedPokemons = pokemons else { return }
        filteredPokemons = loadedPokemons.filter({ (pokemonItem: PokemonData) -> Bool in
            return pokemonItem.name.lowercased().contains(searchText.lowercased())
        })
        mainVC?.updateData()
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
