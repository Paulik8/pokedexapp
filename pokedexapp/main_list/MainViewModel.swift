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
    var pokemons: Pokemon? {
        didSet {
            mainVC!.updateData()
        }
    }
    var notification: NotificationToken?
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
        pokemons = data as? Pokemon
    }
    
    //end
 
    
}
