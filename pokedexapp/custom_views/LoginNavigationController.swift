//
//  LoginNavigationController.swift
//  pokedexapp
//
//  Created by Paulik on 12/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import SwiftUI

class LoginNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        navigationBar.setValue(true, forKey: "hidesShadow")
        navigationBar.barTintColor = Colors.DEFAULT_BACKGROUND
        super.viewDidLoad()
    }
    
}

extension UIHostingController {
    
    func setBlurView() {
        // Init a UIVisualEffectView which going to do the blur for us
        let blurView = UIVisualEffectView()
        // Make its frame equal the main view frame so that every pixel is under blurred
        blurView.frame = view.frame
        // Choose the style of the blur effect to regular.
        // You can choose dark, light, or extraLight if you wants
        blurView.effect = UIBlurEffect(style: .regular)
        // Now add the blur view to the main view
        view.addSubview(blurView)
    }
    
}
