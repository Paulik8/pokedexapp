//
//  StripView.swift
//  pokedexapp
//
//  Created by Paulik on 05/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class StripView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 48, height: 6)
        backgroundColor = Colors.STRIP
        layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
