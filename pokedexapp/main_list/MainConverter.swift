//
//  MainConverter.swift
//  pokedexapp
//
//  Created by Paulik on 21/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation

class MainConverter: Converter {
    
    var imageUrl = "https://img.pokemondb.net/artwork/"
    var pictureExtension = ".jpg"
    
    func convert(name str: String) -> String {
        var changedStr: String = imageUrl
        for el in str.unicodeScalars {
            if (el.value >= 65 && el.value <= 90) || (el.value >= 97 && el.value <= 122) {
                changedStr.append(String(el))
            }
            if (el.value == 9792) {
                changedStr.append("-f")
            }
            if (el.value == 9794) {
                changedStr.append("-m")
            }
        }
        changedStr += pictureExtension
        return changedStr
    }
    
    
}
