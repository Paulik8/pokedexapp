//
//  PokemonListTableViewCell.swift
//  pokedexapp
//
//  Created by Paulik on 03/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class PokemonListTableViewCell: UITableViewCell {
    
    var photo: UIImageView! = {
       let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var name: UITextField! = {
        let name = UITextField()
        name.font = UIFont.systemFont(ofSize: 18.0)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUi() {
        
        contentView.addSubview(photo)
        contentView.addSubview(name)
        
        NSLayoutConstraint.activate([
            
            photo.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            photo.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            photo.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            photo.widthAnchor.constraint(equalToConstant: photo.frame.width),
            photo.heightAnchor.constraint(equalToConstant: photo.frame.height),
            
            name.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 8),
            name.topAnchor.constraint(equalTo: photo.topAnchor)
            ])
    }
    
}
