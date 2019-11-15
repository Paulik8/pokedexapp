//
//  RateCell.swift
//  pokedexapp
//
//  Created by Paulik on 14/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class RateCell: UICollectionViewCell {
    
    var text: UILabel = {
        let text = UILabel()
        text.textColor = Colors.WATER
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUi()
    }
    
    private func setupUi() {
        contentView.addSubview(text)
        
        NSLayoutConstraint.activate([
            text.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            text.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
