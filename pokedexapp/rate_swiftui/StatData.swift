//
//  StatData.swift
//  pokedexapp
//
//  Created by Paulik on 17.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class StatData: Object, Identifiable {
    @objc dynamic var baseStat: Int = 0
    @objc dynamic var effort: Int = 0
    @objc dynamic var stat: SpeciesData? = SpeciesData()
    
    convenience init(baseStat: Int, effort: Int, stat: SpeciesData) {
        self.init()
        self.baseStat = baseStat
        self.effort = effort
        self.stat = stat
    }
    
}
