//
//  ClearViewController.swift
//  pokedexapp
//
//  Created by Paulik on 16.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import SwiftUI

class ClearViewController: UIViewController {
    
    private var chainId: Int?
    private var chainSize: Int?
    
    func setBundle(chainId: Int, chainSize: Int) {
        self.chainId = chainId
        self.chainSize = chainSize
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let paddingTop = view.bounds.height / 3
        var iteration = 0
        guard let chainSize = self.chainSize else { return }
        var subviews = [UIHostingController<RateView>]()
        while (iteration < chainSize) {
            subviews.append(UIHostingController(rootView: RateView(chainId: chainId!, id: iteration)))
            iteration += 1
        }
        let hostVC = RateHostingViewController(rootView: ComplexRateView(topInset: paddingTop, subviews: subviews))
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
