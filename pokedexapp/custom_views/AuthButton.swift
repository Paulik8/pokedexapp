//
//  AuthButton.swift
//  pokedexapp
//
//  Created by Paulik on 31/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class AuthButton: UIButton {
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color  = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUi()
    }
    
   private func setupUi() {
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func disableButton() {
        isEnabled = false
        self.addSubview(indicator)
        
        let leadingConstant = frame.width / 4
        
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingConstant),
//            indicator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -trailingConstant),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        let newLayer = CALayer()
        newLayer.frame = bounds
        newLayer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        guard let index = layer.sublayers?.count else { return }
        layer.insertSublayer(newLayer, at: UInt32(index))
        indicator.startAnimating()
    }
    
    func enableButton() {
        indicator.stopAnimating()
        isEnabled = true
        layer.sublayers?.removeLast()
    }
    
}
