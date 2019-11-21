//
//  MainNotifier.swift
//  pokedexapp
//
//  Created by Paulik on 30/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation

protocol MainNotifier {
    
    func updateData()
    
    func updateRow(row: Int)
    
    func openLogin()
    
    func openProfile()
}
