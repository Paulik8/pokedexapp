//
//  UserObj.swift
//  pokedexapp
//
//  Created by Paulik on 11/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import RealmSwift

class UserObj: Object {
    @objc dynamic var name: String?
    @objc dynamic var password: String?
    @objc dynamic var imageUrl: String?
}
