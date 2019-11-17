//
//  RateViewController.swift
//  pokedexapp
//
//  Created by Paulik on 13/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import SwiftUI

class RateViewController: UIViewController {

    var transitionDelegate: UIViewControllerTransitioningDelegate!
    let collectionIdentifier = "rateCollection"
    
    let viewModel = RateViewModel()
    lazy var collectionView: UICollectionView = {
        let colLayout = UICollectionViewFlowLayout()
        colLayout.scrollDirection = .horizontal
        let col = UICollectionView(frame: .zero, collectionViewLayout: colLayout)
        col.translatesAutoresizingMaskIntoConstraints = false
        col.register(RateCell.self, forCellWithReuseIdentifier: collectionIdentifier)
        col.backgroundColor = .green
        print ("keklik", view.frame)
        return col
    }()
    var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.currentPage = 0
        page.numberOfPages = 0
        page.pageIndicatorTintColor = UIColor(red: 255/255, green: 225/255, blue: 240/255, alpha: 1)
        page.currentPageIndicatorTintColor = UIColor(red: 255/255, green: 135/255, blue: 195/255, alpha: 1)
        page.translatesAutoresizingMaskIntoConstraints = false
        return page
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        print ("keklik", view.frame)
        
//        setupListeners()
//        viewModel.loadEvolution()
    }
    
    override func viewDidLayoutSubviews() {
//        if (!updated) {
//            view.frame = CGRect(x: 0, y: view.frame.height * 0.7, width: view.bounds.width, height: view.frame.height * 0.3)
//            updated = true
//            print ("keklik", view.frame)
//        }
        
    }
    
    private func setupUi() {
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
        view.backgroundColor = .green
//        view.addSubview(collectionView)
//        view.addSubview(pageControl)
//
//        NSLayoutConstraint.activate([
//
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//
//            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
//            pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
//        ])
    }
    
    private func setupListeners() {
        viewModel.rateVC = self
    }
    
}

extension RateViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.speciesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifier, for: indexPath) as! RateCell
        let row = indexPath.row
        cell.text.text = viewModel.speciesArray[row].name
        return cell
    }
    
}

extension RateViewController: BundleDeliver, RateNotifier  {
    
    func updateBundle(id: Int) {
        viewModel.pokemonId = id
//        self.view.frame.size = CGSize(width: 100, height: 100)
//        self.view.setNeedsLayout()
//        self.view.layoutIfNeeded()
    }
    
    func speciesArrayUpdated() {
        DispatchQueue.main.async {
            self.pageControl.numberOfPages = self.viewModel.speciesArray.count
            self.collectionView.reloadData()
        }
    }
    
}

