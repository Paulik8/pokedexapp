//
//  LoginTextField.swift
//  pokedexapp
//
//  Created by Paulik on 24/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {
    
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
    
//    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: insets)
//    }
//    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
}
