//
//  TypeView.swift
//  pokedexapp
//
//  Created by Paulik on 15/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class TypeLabel: UILabel {
    
    let padding: CGFloat = 6.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        super.drawText(in: rect.inset(by: insets))
    }
    
//    override var intrinsicContentSize: CGSize {
//        let size = super.intrinsicContentSize
//        return CGSize(width: size.width + padding * 2,
//                      height: size.height + padding * 2)
//    }
    
}
