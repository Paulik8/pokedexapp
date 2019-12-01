//
//  MainListViewController.swift
//  pokedexapp
//
//  Created by Paulik on 05/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class MainListViewController: UITableViewController {
    
    let logoImageUrl =  "https://firebasestorage.googleapis.com/v0/b/pokedex-f117f.appspot.com/o/logo%2Flogo.png?alt=media&token=71179a3c-735c-4fdb-b04a-7ad627c81186"

    private var viewModel = MainViewModel()
    private let navigationTitle = "Pokemons"
    
    private let tableCellIdentifier = "pokemonTableList"
    private let collectionCellIdentifier = "pokemonCollectionList"
    private let filterCollectionCellIdentifier = "filterCollectionList"
    
    var topNavigationAnchor: NSLayoutConstraint?
    var profileImage: UIButton!
    lazy var filterCollection: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        let col = UICollectionView(frame: view.frame, collectionViewLayout: flowlayout)
        col.register(TypeCollectionViewCell.self, forCellWithReuseIdentifier: filterCollectionCellIdentifier)
        col.translatesAutoresizingMaskIntoConstraints = false
        col.delegate = self
        col.dataSource = self
        col.clipsToBounds = true
        return col
    }()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        let searchBarScopeIsFiltering =
        searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var clicker = 0
    
    var container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        setupListeners()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = navigationTitle
//        DispatchQueue.main.async {
            self.profileImage.isHidden = false
        self.searchController.searchBar.isHidden = false
//            self.searchController = UISearchController(searchResultsController: nil)
//            self.createSearch()
//            self.tableView.setNeedsLayout()
//            self.tableView.layoutIfNeeded()
            
//        }
    }
    
    private func createSearch() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
//        tableView.tableHeaderView = searchController.searchBar
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemons"
        
        searchController.searchBar.delegate = self
        searchController.navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        
//        searchController.searchBar.scopeButtonTitles = Type.allCases.map { $0.rawValue }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (searchController.isActive) {
            title = nil
        }
        searchController.searchBar.isHidden = true
        viewModel.unsubscribe()
    }
    
    private func getData() {
        _ = viewModel.createRequest()
    }
    
    private func setupListeners() {
        viewModel.mainVC = self
    }
    
    private func setupUi() {
        setupNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(PokemonListTableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
        tableView.backgroundColor = .white
        
        
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.estimatedRowHeight = UITableView.automaticDimension
        
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.createSearch()
        DispatchQueue.main.async {
            self.setupFilterType()
        }
        setupProfileLogo()
    }
    
    private func setupFilterType() {
        container.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 34)
        
        filterCollection.backgroundColor = .red
        
//        container.addSubview(searchController.searchBar)
        container.addSubview(filterCollection)
        
//        tableView.tableHeaderView?.addSubview(filterCollection)
//        guard let navbar = navigationController?.navigationBar else { return }
        let navbar = searchController.searchBar
//        tableView.tableHeaderView?.addSubview(filterCollection)
            
//        self.tableView.tableHeaderView = container
        
        self.tableView.tableHeaderView = container
        
         NSLayoutConstraint.activate([
            filterCollection.topAnchor.constraint(equalTo: container.topAnchor),
            filterCollection.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            filterCollection.widthAnchor.constraint(equalToConstant: filterCollection.frame.width),
            filterCollection.heightAnchor.constraint(equalToConstant: 34),
            
            container.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
            container.widthAnchor.constraint(equalTo: self.tableView.widthAnchor),
            container.heightAnchor.constraint(equalToConstant: container.frame.height),
            container.topAnchor.constraint(equalTo: self.tableView.topAnchor)
        ])
        
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
        tableView.layoutIfNeeded()
        
//        hideFilterScopes()
    }
    
    private func hideFilterScopes() {
        container.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: searchController.searchBar.frame.height)
        filterCollection.isHidden = true
    }
    
    private func showFilterScopes() {
        filterCollection.reloadData()
//        container.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: searchController.searchBar.frame.height + 40)
        filterCollection.isHidden = false
        self.tableView.tableHeaderView?.frame = container.frame
        tableView.layoutIfNeeded()
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
    }
    
    private func setupProfileLogo() {
        profileImage = UIButton()
        
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        viewModel.unsubscribe()
//    }

}

extension MainListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let kek =  collectionView.tag
        clicker += 1
//        self.filterCollection.reloadData()
        self.showFilterScopes()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == filterCollection) {
            return clicker
        } else {
            guard let pokes = viewModel.pokemons else { return 0 }
            if (isFiltering) {
                if (viewModel.filteredPokemons.count <= collectionView.tag) {
                    return 0
                }
                return viewModel.filteredPokemons[collectionView.tag].type.count
            }
            return pokes[collectionView.tag].type.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == filterCollection) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCollectionCellIdentifier, for: indexPath) as! TypeCollectionViewCell
            let type = "Grass"
            cell.type.text = type
            cell.type.backgroundColor = cell.changeColor(type)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! TypeCollectionViewCell
            guard let pokes = viewModel.pokemons else { return cell }
            let currentType: String
            if (isFiltering) {
                print("kekType", collectionView.tag, indexPath.item)
                currentType = viewModel.filteredPokemons[collectionView.tag].type[indexPath.item]
            } else {
                print("kekType", collectionView.tag, indexPath.item)
                currentType = pokes[collectionView.tag].type[indexPath.item]
            }
            cell.type.text = currentType
            cell.type.backgroundColor = cell.changeColor(currentType)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell: TypeCollectionViewCell
        if (collectionView == filterCollection) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCollectionCellIdentifier, for: indexPath) as! TypeCollectionViewCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! TypeCollectionViewCell
        }
        
        return CGSize(width: cell.type.frame.width, height: cell.type.frame.height)
    }
    
}

extension MainListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pokes = viewModel.pokemons else { return 0 }
        if (isFiltering) {
            return viewModel.filteredPokemons.count
        }
        return pokes.count
    }
    
}

extension MainListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            let row = indexPath.row
//            guard let pokemons = viewModel.pokemons else { return }
//            if let _ = viewModel.pokemonImages[pokemons[row].nationalNumber] {
//            } else {
//                viewModel.fetchPokemons(indexOf: row, isImportant: false, nil) {
////                    if (tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false) {
////                        cell.photo.image = self.viewModel.pokemonImages[$0!]
////                    }
//                }
//            }
//        }
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            viewModel.cancelFetchPokemons(indexOf: indexPath.row)
//        }
    }
    
}

extension MainListViewController {
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////        if (searchController.isActive) {
////            return 44
////        } else {
////            return  0
////        }
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as! PokemonListTableViewCell
        let row = indexPath.row
        guard let pokemons = viewModel.pokemons else { return cell }
        let currentPokemon: PokemonData
        if (isFiltering) {
            currentPokemon = viewModel.filteredPokemons[row]
        } else {
            currentPokemon = pokemons[row]
        }
        cell.tag = row
        cell.name.text = currentPokemon.name
        if let image = viewModel.pokemonImages[currentPokemon.nationalNumber] {
            cell.photo.image = image
        } else {
            viewModel.fetchPokemons(indexOf: row, isImportant: true, isFiltering) {
//                cell.photo.image = self.viewModel.pokemonImages[currentPokemon.nationalNumber]
                tableView.reloadData()
//                else {
//                tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
//                }
//                if (tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false) {
                    
//                }
            }
        }
//        cell.photo.loadImageFromUrl(currentPokemon.sprites.large) {}
        cell.changeCollectionViewWidth(calculateCollectionWidth(item: 72, space: 12, itemCount: currentPokemon.type.count))
        cell.setCollectionViewData(source: self, row: row)
        return cell
    }
    
    private func calculateCollectionWidth(item: CGFloat, space: CGFloat, itemCount: Int) -> CGFloat {
        return item * CGFloat(itemCount) + space * CGFloat(itemCount - 1)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if (searchController.isActive) {
            searchController.searchBar.endEditing(true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("keklikcancel", indexPath.row)
        viewModel.cancelFetchPokemons(indexOf: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let pokes = viewModel.pokemons else { return }
        let row = indexPath.row
        let  curPokemon: PokemonData
        if (isFiltering) {
            curPokemon = viewModel.filteredPokemons[row]
        } else {
            curPokemon = pokes[indexPath.row]
        }
        let name = curPokemon.name.lowercased()
        let id = Int(curPokemon.nationalNumber) ?? 2
        profileImage.isHidden = true //
        searchController.searchBar.endEditing(true)
        searchBarCancelButtonClicked(searchController.searchBar)
//        navigationController?.navigationBar.prefersLargeTitles = false
        let infoVC = InfoViewController()//
        infoVC.setPokemonName(name: name)//
        infoVC.setPokemonId(id: id, imageId: curPokemon.nationalNumber)
        self.navigationController?.pushViewController(infoVC, animated: true) //
    }
    
    private func endEditing() {
        if (isFiltering || searchController.isActive) {
            searchController.searchBar.endEditing(true)
            searchController.searchBar.isHidden = true
        }
    }
    
}

extension MainListViewController: MainNotifier {
    
    func updateData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateRow(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        if (tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false) {
            tableView.reloadRows(at: [indexPath], with: .none)
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

extension MainListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        guard let category = Type(rawValue: searchBar.scopeButtonTitles![selectedScope]) else { return }
        viewModel.filteredDataForSearch(filter: searchBar.text!, isSearchBarEmpty: isSearchBarEmpty, category: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
//        showFilterScopes()
//        guard let category = Type(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]) else { return }
        viewModel.filteredDataForSearch(filter: searchBar.text!, isSearchBarEmpty: isSearchBarEmpty, category: nil)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        profileImage.isHidden = true
        return true
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        profileImage.isHidden = true
//    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.showsScopeBar = false
//        profileImage.isHidden = false
    }
    
}
