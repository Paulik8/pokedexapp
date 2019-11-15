//
//  InfoViewController.swift
//  pokedexapp
//
//  Created by Paulik on 19/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    let transitionDelegate: UIViewControllerTransitioningDelegate = TransitionDelegate()
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(containerClicked))
        container.addGestureRecognizer(tap)
    }
    
    @objc private func containerClicked() {
        let rateVC = RateViewController()

//        rateVC.modalPresentationStyle = .formSheet
        rateVC.updateBundle(id: viewModel.pokemonInfo!.id)
//        self.transitioningDelegate = transitionDelegate
        rateVC.transitioningDelegate = self
        rateVC.modalPresentationStyle = .custom
        self.present(rateVC, animated: true, completion: nil)
//        rateVC.view.frame = CGRect(x: 0, y: 0, width: 400, height: 600)
        
//        present(rateVC, animated: true, completion: nil)
//        rateVC.view.frame = CGRect(x: 0, y: rateVC.view.frame.height * 0.7, width: rateVC.view.bounds.width, height: rateVC.view.frame.height * 0.3)
//        rateVC.view.clipsToBounds = true
    }

}

extension InfoViewController: SubscriberDelegate, UIViewControllerTransitioningDelegate {
    
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
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    
}

class HalfSizePresentationController : UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
           guard let container = containerView else { return .zero }
           
        return CGRect(x: 0, y: 150, width: container.bounds.width, height: container.bounds.height - 150)
       }
    
//    func frameOfPresentedViewInContainerView() -> CGRect {
//        return CGRect(x: 0, y: containerView!.bounds.height/2, width: (containerView?.bounds.width)!, height: (containerView?.bounds.height)!/2)
//    }
}
