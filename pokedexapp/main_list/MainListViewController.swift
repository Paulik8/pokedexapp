//
//  MainListViewController.swift
//  pokedexapp
//
//  Created by Paulik on 05/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class MainListViewController: UIViewController {
    
    let logoImageUrl = "https://firebasestorage.googleapis.com/v0/b/pokedex-f117f.appspot.com/o/logo%2Flogo.png?alt=media&token=71179a3c-735c-4fdb-b04a-7ad627c81186"

    private var viewModel = MainViewModel()
    private let navigationTitle = "Pokemons"
    
    private let tableCellIdentifier = "pokemonTableList"
    private let collectionCellIdentifier = "pokemonCollectionList"
    
    var topNavigationAnchor: NSLayoutConstraint?
    
    private var listTableView: UITableView!
    var profileImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        setupListeners()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileImage.isHidden = false
    }
    
    private func getData() {
        _ = viewModel.createRequest()
    }
    
    private func setupListeners() {
        viewModel.mainVC = self
    }
    
    private func setupUi() {
        listTableView = {
            let table = UITableView(frame: .zero, style: .plain)
            table.translatesAutoresizingMaskIntoConstraints = false
            table.estimatedRowHeight = UITableView.automaticDimension
            table.delegate = self
            table.dataSource = self
            table.register(PokemonListTableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
            return table
        }()
    
        setupNavigationBar()
        
        view.addSubview(listTableView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            listTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            listTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
    }
    
    private func setupNavigationBar() {
        title = navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        setupProfileLogo()
    }
    
    private func setupProfileLogo() {
        profileImage = UIButton()
        
//        let profileUrl = 
        if (!AuthRepository.shared.getProfileLogoStatus()) {
            profileImage.setImage(#imageLiteral(resourceName: "logo"), for: .normal)
        }
        profileImage.imageView?.contentMode = .scaleAspectFill
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.addSubview(profileImage)
        profileImage.frame = CGRect(x: 0, y: 0, width: NavigationConstants.ImageSizeForLargeState, height: NavigationConstants.ImageSizeForLargeState)
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = NavigationConstants.ImageSizeForLargeState / 2
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: navBar.topAnchor, constant: NavigationConstants.ImageTopMarginForLargeState),
            profileImage.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -NavigationConstants.ImageRightMargin),
            profileImage.heightAnchor.constraint(equalToConstant: profileImage.frame.height),
            profileImage.widthAnchor.constraint(equalToConstant: profileImage.frame.height)
        ])
        profileImage.addTarget(self, action: #selector(profileClicked), for: .touchUpInside)
        profileImage.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTouchProfile)))
    }
    
    @objc private func longTouchProfile(state: UILongPressGestureRecognizer) {
        if state.state == .ended {
            viewModel.profileLongTouched()
        }
   
    }
    
    private func moveAndResizeImage(for height: CGFloat) { // viewModel or viewController
        let coeff: CGFloat = {
            let delta = height - NavigationConstants.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (NavigationConstants.NavBarHeightLargeState - NavigationConstants.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = NavigationConstants.ImageSizeForSmallState / NavigationConstants.ImageSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        let sizeDiff = NavigationConstants.ImageSizeForLargeState * (1.0 - factor)
        
        let y: CGFloat = {
            let y = (1 - scale) * (NavigationConstants.ImageSizeForLargeState + NavigationConstants.ImageTopMarginForLargeState)
            return max (0, y)
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        profileImage.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: -(1 + scale) * y)
    }
    
    @objc private func profileClicked() {
        viewModel.profileClicked()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.unsubscribe()
    }

}

extension MainListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pokemons?.results[collectionView.tag].type.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! TypeCollectionViewCell
        guard let currentType = viewModel.pokemons?.results[collectionView.tag].type[indexPath.item] else { return cell }
        cell.type.text = currentType
        cell.type.backgroundColor = cell.changeColor(currentType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! TypeCollectionViewCell
        return CGSize(width: cell.type.frame.width, height: cell.type.frame.height)
    }
    
}

extension MainListViewController:  UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemons?.results.count ?? 0
    }
    
}

extension MainListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as! PokemonListTableViewCell
        let row = indexPath.row
        guard let pokemons = viewModel.pokemons?.results else { return cell }
        let currentPokemon = pokemons[row]
        cell.name.text = currentPokemon.name
        cell.photo.loadImageFromUrl(currentPokemon.sprites.large) {}
        cell.setCollectionViewData(source: self, row: row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let name = viewModel.pokemons?.results[indexPath.row].name.lowercased() else { return }
        profileImage.isHidden = true //
        let infoVC = InfoViewController()//
        infoVC.setPokemonName(name: name)//
        self.navigationController?.pushViewController(infoVC, animated: true) //
    }
    
}

extension MainListViewController: MainNotifier {
    
    func updateData() {
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
    
    func openLogin() {
        profileImage.isHidden = true
        let loginVC = LoginViewController()
        navigationController?.viewControllers.removeFirst()
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = LoginNavigationController(rootViewController: loginVC)
    }
    
    func openProfile() {
        let profileVC = ProfileViewController()
        profileVC.modalPresentationStyle = .formSheet
        present(profileVC, animated: true, completion: nil)
    }
}
