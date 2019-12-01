//
//  PokemonListTableViewCell.swift
//  pokedexapp
//
//  Created by Paulik on 03/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class PokemonListTableViewCell: UITableViewCell {
    
    private  let collectionCellIdentifier = "pokemonCollectionList"
    var collectionViewWidthConstraint: NSLayoutConstraint?
    
    lazy var photo: UIImageView! = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var name: UITextField! = {
        let name = UITextField()
        name.isUserInteractionEnabled = false
        name.font = UIFont.systemFont(ofSize: 18.0)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var collection: UICollectionView! = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        let col = UICollectionView(frame: contentView.frame, collectionViewLayout: flowlayout)
        col.register(TypeCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellIdentifier)
        col.translatesAutoresizingMaskIntoConstraints = false
        return col
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
    }
    
    func setCollectionViewData(source: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout, row: Int) {
        collection.backgroundColor = .clear
        collection.delegate = source
        collection.dataSource = source
        collection.tag = row
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }
    
    private func setupUi() {
        
        contentView.addSubview(photo)
        contentView.addSubview(name)
        contentView.addSubview(collection)
        
        collectionViewWidthConstraint = collection.widthAnchor.constraint(equalToConstant: contentView.frame.width)

        NSLayoutConstraint.activate([

            photo.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            photo.topAnchor.constraint(equalTo: contentView.topAnchor),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photo.widthAnchor.constraint(equalToConstant: photo.frame.width),
            photo.heightAnchor.constraint(equalToConstant: photo.frame.height),

            name.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 8),
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            collection.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            collection.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            collection.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 8),
            collection.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            collectionViewWidthConstraint!,
            collection.heightAnchor.constraint(equalToConstant: collection.frame.height)
            ])
    }
    
    func changeCollectionViewWidth(_ width: CGFloat) {
        collectionViewWidthConstraint?.constant = width
    }
    
}
