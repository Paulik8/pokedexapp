//
//  PokemonExtension.swift
//  dev
//
//  Created by Paulik on 08/09/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageFromUrl(_ urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if err != nil { return }
            guard let image = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: image)
            }
            }.resume()
    }
}

extension Array {
    func getUniquePokemons<T: Hashable>(_ field: (Element) -> T) -> [Element] {
        var buffer = [Element]()
        var keys = Set<T>()
        
        for value in self {
            if (!keys.contains(field(value))) {
                buffer.append(value)
                keys.insert(field(value))
            }
        }
        
        return buffer
    }
    
    func shorted() -> [Element] {
        var buf = [Element]()
        var counter = 0
        for val in self {
            counter += 1
            if (counter == 2) {
                return buf
            }
            buf.append(val)
        }
        return buf
    }
}
