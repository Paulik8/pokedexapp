//
//  ImageLoader.swift
//  pokedexapp
//
//  Created by Paulik on 18.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import Combine

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    let cacheManager = CacheManager.shared

    init(urlString: String) {
        if (urlString.count == 0) {
            return
        }
        let id = getImageIdFromUrl(urlString)
        if let cachedImage = cacheManager.getCachedImage(id: id) {
            DispatchQueue.main.async {
                print("keklikView", "cached")
                self.data = cachedImage.pngData()!
            }
        } else {
            guard let url = URL(string: urlString + id + ".png") else { return }
            URLSession.shared.dataTask(with: url) { (data, res, err) in
                if err != nil {
                    print("keklik", err)
                    return }
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    print("keklikView", "not cached")
                    self.data = imageData
                }
//                    cacheManager.cacheImage(id: id, data: decodedImage)
            }.resume()
        }
    }
    
    private func getImageIdFromUrl(_ url: String) -> String {
        let splitted = url.split(separator: "/")
        let splittedStr = splitted[splitted.count - 1]
        let id = String(splittedStr.split(separator: ".")[0])
        return id
    }
    
}
