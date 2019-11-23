//
//  InfoViewController.swift
//  pokedexapp
//
//  Created by Paulik on 19/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import SwiftUI

class InfoViewController: UIViewController {
    
    var hostVC: UIHostingController<RateView>!
    let transitionDelegate: UIViewControllerTransitioningDelegate = TransitionDelegate()
    var viewModel = InfoViewModel()
    
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
        viewModel.pokemonName = name
        title = viewModel.pokemonName
    }
    
    func setPokemonId(id: Int, imageId: String) {
        viewModel.pokemonId = id
        viewModel.idForImage = imageId
        viewModel.createRequest(name: viewModel.pokemonName!, id: viewModel.pokemonId!)
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
    
    func setBlurView() {
        // Init a UIVisualEffectView which going to do the blur for us
        let blurView = UIVisualEffectView()
        // Make its frame equal the main view frame so that every pixel is under blurred
        blurView.frame = view.frame
        // Choose the style of the blur effect to regular.
        // You can choose dark, light, or extraLight if you wants
        blurView.effect = UIBlurEffect(style: .regular)
        // Now add the blur view to the main view
        view.addSubview(blurView)
    }
    
    @objc private func containerClicked() {
        guard let chainId = viewModel.chainId else { return }
        let clearVC = ClearViewController()
        clearVC.setBundle(id: chainId)
        clearVC.modalPresentationStyle = .overFullScreen
        
        present(clearVC, animated: false) {
            UIView.animate(withDuration: 0.4) {
                clearVC.view?.backgroundColor = UIColor(white: -1, alpha: 0.5)
            }
        }
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

final class RateHostingViewController: UIHostingController<RateView> {
    
    var clearVC: ClearNotifier?
    
    override init(rootView: RateView) {
        super.init(rootView: rootView)
        setListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 1) {
//            self.view.backgroundColor = UIColor(white: -1, alpha: 0.5)
//        }
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setListener() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
//        self.view.addGestureRecognizer(tap)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchPoint = touch?.location(in: self.view)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchPoint = touch?.location(in: self.view)
        guard let point = touchPoint else { return }
        guard let rootViewTopInset = rootView.topInset else { return }
        if (point.y < rootViewTopInset) {
            tapped()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    private func tapped() {
        dismiss(animated: true)
        clearVC?.dismiss()
    }
    
}

class HalfSizePresentationController : UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
           guard let container = containerView else { return .zero }
        let offsetY: CGFloat = 400
           
        return CGRect(x: 0, y: offsetY, width: container.bounds.width, height: container.bounds.height - offsetY)
       }
    
//    func frameOfPresentedViewInContainerView() -> CGRect {
//        return CGRect(x: 0, y: containerView!.bounds.height/2, width: (containerView?.bounds.width)!, height: (containerView?.bounds.height)!/2)
//    }
}
