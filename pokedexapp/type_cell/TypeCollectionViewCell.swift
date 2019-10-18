//
//  TypeCollectionViewCell.swift
//  pokedexapp
//
//  Created by Paulik on 16/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    
    var type: TypeLabel! = {
        let type = TypeLabel(frame: CGRect(x: 0, y: 0, width: 72, height: 32))
//        type.sizeToFit()
        type.clipsToBounds = true
        type.textAlignment = .center
        type.textColor = Colors.TYPELABEL_TEXT
//        type.backgroundColor = UIColor(red: 97/255, green: 176/255, blue: 236/255, alpha: 1)
        type.layer.cornerRadius = 10
        type.translatesAutoresizingMaskIntoConstraints = false
        return type
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func changeColor(_ type: String) -> UIColor {
        let color: UIColor
        if let typeCase = Type(rawValue: type) {
            switch typeCase {
            case Type.grass:
                color = Colors.GRASS
            case Type.water:
                color = Colors.WATER
            case Type.dragon:
                color = Colors.DRAGON
            case Type.poison:
                color = Colors.POISON
            case Type.fire:
                color = Colors.FIRE
            default:
                color = UIColor.black
            }
        } else {
            color = UIColor.blue
        }
        return color
    }
    
    private func setupUi() {
        contentView.addSubview(type)
        
        NSLayoutConstraint.activate([
            type.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            type.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            type.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            type.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            type.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
