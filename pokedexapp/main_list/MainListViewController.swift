//
//  MainListViewController.swift
//  pokedexapp
//
//  Created by Paulik on 05/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class MainListViewController: UIViewController {

    private var viewModel = MainViewModel()
    private let navigationTitle = "Pokemons"
    
    private let cellIdentifier = "pokemonList"
    
    private var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        setupListeners()
        getData()
    }
    
    private func getData() {
        _ = viewModel.createRequest()
    }
    
    private func setupListeners() {
        viewModel.delegate = self
    }
    
    private func setupUi() {
        listTableView = {
            let table = UITableView(frame: .zero)
            table.translatesAutoresizingMaskIntoConstraints = false
            table.estimatedRowHeight = UITableView.automaticDimension
            table.delegate = self
            table.dataSource = self
            table.register(PokemonListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
            return table
        }()
        title = navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(listTableView)
        
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            listTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            listTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            listTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            ])
        
    }

}

extension MainListViewController:  UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemons?.results.count ?? 0
    }
    
}

extension MainListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PokemonListTableViewCell
        let row = indexPath.row
        guard let pokemons = viewModel.pokemons?.results else { return cell }
        let currentPokemon = pokemons[row]
        cell.name.text = currentPokemon.name
        cell.photo.loadImageFromUrl(currentPokemon.sprites.large)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MainListViewController: SubscriberDelegate {
    
    func notify() {
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
}
