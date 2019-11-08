//
//  AuthPasswordButton.swift
//  pokedexapp
//
//  Created by Paulik on 08/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class AuthPasswordButton: AuthButton {
    
    var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color  = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUi()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupUi() {
        super.setupUi()
        self.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
    override func disableButton() {
        indicator.startAnimating()
        super.disableButton()
    }
    
    override func enableButton() {
        indicator.stopAnimating()
        super.enableButton()
    }
    
}
