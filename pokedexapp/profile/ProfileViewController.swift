//
//  ProfileViewController.swift
//  pokedexapp
//
//  Created by Paulik on 02/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var strip: StripView = {
        let strip = StripView()
        strip.translatesAutoresizingMaskIntoConstraints = false
        return strip
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    private func setupUi() {
        view.backgroundColor = Colors.DEFAULT_BACKGROUND
        view.addSubview(strip)
        
        NSLayoutConstraint.activate([
            strip.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            strip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            strip.heightAnchor.constraint(equalToConstant: strip.frame.height),
            strip.widthAnchor.constraint(equalToConstant: strip.frame.width)
        ])

    }

}
