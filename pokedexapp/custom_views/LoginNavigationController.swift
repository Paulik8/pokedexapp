//
//  LoginNavigationController.swift
//  pokedexapp
//
//  Created by Paulik on 12/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class LoginNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        navigationBar.setValue(true, forKey: "hidesShadow")
        navigationBar.barTintColor = Colors.DEFAULT_BACKGROUND
        super.viewDidLoad()
    }
    
}
