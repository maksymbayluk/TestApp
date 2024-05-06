//
//  AppsViewController.swift
//  TestApp
//
//  Created by Максим Байлюк on 04.05.2024.
//

import UIKit
import SwiftyDropbox

class AppsViewController: UIViewController, NetworkUIUpdateDelegate {
    
    private lazy var collectionView = setUpCollectionView()
    private var searchBar: UISearchBar!
    private var filteredData: [String] = []
    static let shared = AppsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        view.addSubview(collectionView)
        setupConstraints()
        NetworkManager.shared.fetchData()
    }
    //MARK: - SEARCH BAR UI
    func setUpSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = false
        view.addSubview(searchBar)
    }
    
    //MARK: - COLLECTION VIEW UI
    func setUpCollectionView() -> UICollectionView {
        let layout = AppsCompositionalLayout()
        
        // Initialize collection view
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = .white
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.isHidden = false
        let nib = UINib(nibName: "AppsCollectionViewCell", bundle: nil)
        collectionview.register(nib, forCellWithReuseIdentifier: "AppsCollectionCell")
        return collectionview
    }
    func updateUI() {
        self.view.layoutIfNeeded()
        if !NetworkManager.shared.data.isEmpty {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        //loader
    }
    
    //MARK: - CONSTRAINTS & LAYOUT
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func AppsCompositionalLayout() -> UICollectionViewCompositionalLayout {

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                    // Define item size
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(80))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            // Define group size
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(8)
            // Create section
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            return section
        }
        return layout
    }
    

}

//MARK: - SEARCH DELEGATE

extension AppsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search text is \(searchText)")
        filterContentForSearchText(searchText)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        deactivateSearchBar()
    }
    func deactivateSearchBar() {
        searchBar.resignFirstResponder()
    }
    
    private func filterContentForSearchText(_ searchText: String) {
//        filteredData = NetworkManager.shared.data?.filter { item in
//            return item.lowercased().contains(searchText.lowercased())
//        }
        collectionView.reloadData()
    }
    private func isFiltering() -> Bool {
        return searchBar.text != ""
    }
    
    
}


//MARK: - COLLECTION VIEW DELEGATE AND DATASOURCE

extension AppsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            print(filteredData.count)
            return filteredData.count
        } else {
            print(NetworkManager.shared.data.count)
            return NetworkManager.shared.data.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppsCollectionCell", for: indexPath) as! AppsCollectionViewCell
        let item: String
        let data = NetworkManager.shared.data
        print(data[0].title)
        if isFiltering() {
            item = filteredData[indexPath.item]
        } else {
            item = data[indexPath.item].title
        }
        cell.AppLbl.text = item
        
        return cell
    }
    
}
