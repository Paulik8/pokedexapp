//
//  PokemonExtension.swift
//  dev
//
//  Created by Paulik on 08/09/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import SystemConfiguration
import UIKit

extension UIImageView {
    func loadImageFromUrl(_ urlStr: String, _ callback: @escaping () -> Void) {
        guard let url = URL(string: urlStr) else { return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if err != nil {
                print("keklik", err)
                return }
            guard let image = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: image)
                callback()
            }
        }.resume()
    }
    
    func loadImagePng(_ urlStr: String, _ id: String,  _ callback: @escaping () -> Void) {
        let cacheManager = CacheManager.shared
        if let cachedImage = cacheManager.getCachedImage(id: id) {
            DispatchQueue.main.async {
                print("kekliKCached", id)
                self.image = cachedImage
                callback()
            }
        } else {
            guard let url = URL(string: urlStr + id + ".png") else { return }
            URLSession.shared.dataTask(with: url) { (data, res, err) in
                if err != nil {
                    print("keklik", err)
                    return }
                guard let image = data else { return }
                guard let decodedImage = UIImage(data: image) else { return }
                DispatchQueue.main.async {
                    self.image = decodedImage
                    print("kekliKNotCached", id)
                    cacheManager.cacheImage(id: id, data: decodedImage)
                    callback()
                }
            }.resume()
        }
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

public extension UIDevice {
  static let modelName: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    
    func mapToDevice(identifier: String) -> String {
      #if os(iOS)
      switch identifier {
      case "iPod5,1":                                 return "iPod Touch 5"
      case "iPod7,1":                                 return "iPod Touch 6"
      case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
      case "iPhone4,1":                               return "iPhone 4s"
      case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
      case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
      case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
      case "iPhone7,2":                               return "iPhone 6"
      case "iPhone7,1":                               return "iPhone 6 Plus"
      case "iPhone8,1":                               return "iPhone 6s"
      case "iPhone8,2":                               return "iPhone 6s Plus"
      case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
      case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
      case "iPhone8,4":                               return "iPhone SE"
      case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
      case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
      case "iPhone10,3", "iPhone10,6":                return "iPhone X"
      case "iPhone11,2":                              return "iPhone XS"
      case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
      case "iPhone11,8":                              return "iPhone XR"
      case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
      case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
      case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
      case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
      case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
      case "iPad6,11", "iPad6,12":                    return "iPad 5"
      case "iPad7,5", "iPad7,6":                      return "iPad 6"
      case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
      case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
      case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
      case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
      case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
      case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
      case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
      case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
      case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
      case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
      case "AppleTV5,3":                              return "Apple TV"
      case "AppleTV6,2":                              return "Apple TV 4K"
      case "AudioAccessory1,1":                       return "HomePod"
      case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
      default:                                        return identifier
      }
      #elseif os(tvOS)
      switch identifier {
      case "AppleTV5,3": return "Apple TV 4"
      case "AppleTV6,2": return "Apple TV 4K"
      case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
      default: return identifier
      }
      #endif
    }
    
    return mapToDevice(identifier: identifier)
  }()
}
