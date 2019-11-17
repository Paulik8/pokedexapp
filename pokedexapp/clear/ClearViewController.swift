//
//  ClearViewController.swift
//  pokedexapp
//
//  Created by Paulik on 16.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class ClearViewController: UIViewController {
    
    private var id: Int?
    
    func setBundle(id: Int) {
        self.id = id
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let paddingTop = view.bounds.height / 3
        let hostVC = RateHostingViewController(rootView: RateView(topInset: paddingTop, id: self.id!))
        hostVC.clearVC = self
        hostVC.view?.backgroundColor = UIColor.clear
        hostVC.modalPresentationStyle = .overFullScreen
        present(hostVC, animated: true, completion: nil)
    }
    
}

extension ClearViewController: ClearNotifier {

    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
             self.view.backgroundColor = .clear
        }) { (_) in
            self.dismiss(animated: false)
        }
    }
    
}
