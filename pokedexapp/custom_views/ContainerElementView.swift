//
//  ContainerElement.swift
//  pokedexapp
//
//  Created by Paulik on 19/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class ContainerElementView: UIView {
    
    let labelColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    let valueColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let font = UIFont.systemFont(ofSize: 17, weight: .regular)
    
    lazy var elementLabel: UILabel = {
        let label = UILabel()
        label.textColor = self.labelColor
        label.font = self.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var elementValue: UILabel = {
        let value = UILabel()
        value.textColor = self.valueColor
        value.textAlignment = .center
        value.font = self.font
        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUi()
        setupLayout()
    }
    
    private func setupUi() {
        self.addSubview(elementLabel)
        self.addSubview(elementValue)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            elementLabel.topAnchor.constraint(equalTo: self.topAnchor),
            elementLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            elementLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            elementValue.topAnchor.constraint(equalTo: elementLabel.bottomAnchor, constant: 8),
            elementValue.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            elementValue.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
