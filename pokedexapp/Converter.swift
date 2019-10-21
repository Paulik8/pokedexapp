//
//  Converter.swift
//  pokedexapp
//
//  Created by Paulik on 21/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation

protocol Converter {
    var imageUrl: String { get }
    var pictureExtension: String { get }
    func convert(name: String) -> String
    
}
