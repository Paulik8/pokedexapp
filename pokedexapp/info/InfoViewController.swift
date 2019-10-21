//
//  InfoViewController.swift
//  pokedexapp
//
//  Created by Paulik on 19/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var viewModel = InfoViewModel()
    var pokemonName: String? {
        didSet {
            title = pokemonName
            self.viewModel.createRequest(name: pokemonName!)
        }
    }
    
    var photo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var container: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 10
        container.backgroundColor = Colors.WATER
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    var height: ContainerElementView = {
        let height = ContainerElementView()
        height.elementLabel.text = "Height"
        height.translatesAutoresizingMaskIntoConstraints = false
        return height
    }()
    
    var weight: ContainerElementView = {
        let weight = ContainerElementView()
        weight.elementLabel.text = "Weight"
        weight.translatesAutoresizingMaskIntoConstraints = false
        return weight
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        setupListeners()
    }
    
    func setPokemonName(name: String) {
        pokemonName = name
    }
    
    private func setupUi() {
        view.backgroundColor = Colors.DEFAULT_BACKGROUND
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(photo)
        view.addSubview(container)
        view.addSubview(height)
        view.addSubview(weight)
        
        NSLayoutConstraint.activate([
            
            photo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photo.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height/4),
            
            container.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            container.heightAnchor.constraint(equalToConstant: 100),
            
            height.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            height.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            
            weight.topAnchor.constraint(equalTo: height.topAnchor),
            weight.leadingAnchor.constraint(equalTo: height.trailingAnchor, constant: 8)
            
        ])
    }
    
    private func setupListeners() {
        viewModel.subscriber = self
    }

}

extension InfoViewController: SubscriberDelegate {
    
    func notify() {
        
        DispatchQueue.main.async {
            if let data = self.viewModel.pokemonInfo {
                self.height.elementValue.text = "\(data.height)"
                self.weight.elementValue.text = "\(data.weight)"
            }
        
            if let image = self.viewModel.poster.image {
                self.photo.image = image
            }
        }
    }
}
