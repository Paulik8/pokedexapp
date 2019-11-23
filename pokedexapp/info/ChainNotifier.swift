//
//  ChainNotifier.swift
//  pokedexapp
//
//  Created by Paulik on 23.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation

protocol ChainNotifier {
    
    func chainResolved(chain: Chain)
    
    func setChainId(id: Int)

}
