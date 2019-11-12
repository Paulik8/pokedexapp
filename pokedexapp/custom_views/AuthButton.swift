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
        if (UIDevice.modelName == "Simulator iPhone SE") {
            self.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
            self.layer.cornerRadius = 18
        } else {
            self.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 64))
            self.layer.cornerRadius = 30
        }
        setupUi()
    }
    
    private func setupUi() {
        setTitleColor(UIColor.white, for: .normal)
    }
    
    func setupIndicator() {
        self.addSubview(indicator)
            
        let leadingConstant = frame.width / 4
        
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingConstant),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func disableButton() {
        isEnabled = false
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
