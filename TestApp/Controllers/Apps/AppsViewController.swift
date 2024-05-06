//
//  AppsViewController.swift
//  TestApp
//
//  Created by Максим Байлюк on 04.05.2024.
//

import UIKit
import SwiftyDropbox


class AppsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var noInternetVC = NoInternetVC()
    
    private var filteredData: [AppCategoryModel] = []
    static let shared = AppsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(nointernet(notification:)), name: NSNotification.Name(rawValue: "internetcheck"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(internet(notification:)), name: NSNotification.Name(rawValue: "internetcheckOK"), object: nil)
        
        getData()

    }
    override func viewWillAppear(_ animated: Bool) {
        Reachability.shared.IsNetworkAvailable()
        if NetworkManager.shared.data.isEmpty {
            getData()
        }
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    //MARK: - INTERNET CHECK
    @objc func nointernet(notification: NSNotification) {
        noInternetVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(noInternetVC, animated: true)
    }
    @objc func internet(notification: NSNotification) {
        if NetworkManager.shared.data.count == 0 {
            getData()
        }
        noInternetVC.dismiss(animated: true)
    }
    //MARK: - SEARCH BAR UI
    func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = false
    }
    
    //MARK: - COLLECTION VIEW UI
    func setUpCollectionView() {
        let layout = AppsCompositionalLayout()
        collectionView.collectionViewLayout = layout
        collectionView.frame = .zero
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "AppsCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "AppsCollectionCell")
    }
    func getData() {
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        NetworkManager.shared.fetchData { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                switch error as! CallError<Any> {
                case .routeError:
                    let alertWithCompletion = Service.createAlertController(title: "No data initialized for this user", message: "wrong user signed in") {
                        let guest = GuestViewController()
                        DropBoxAuth.presentDropboxLogout(from: self) {
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(vc: guest)
                        }
                            
                    }
                    self.present(alertWithCompletion, animated: true)
                default:
                    let alert = Service.createAlertController(title: "Error", message: "something wrong with a server")
                    self.present(alert, animated: true)
                    
                }
                // Handle error, for example, show an alert
                activityIndicator.stopAnimating()
                activityIndicator.alpha = 0
                let alert = Service.createAlertController(title: error.localizedDescription, message: "")
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            // Data fetched successfully, update UI or perform other tasks
            if let data = data {
                activityIndicator.stopAnimating()
                activityIndicator.alpha = 0
                NetworkManager.shared.data = data
                // Update UI or perform tasks with the fetched data
                DispatchQueue.main.async {
                    self.setUpCollectionView()
                    self.setUpSearchBar()
                }
                
            }
        }
    }
    
    //MARK: - CONSTRAINTS & LAYOUT
    
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
        filterContentForSearchText(searchText)
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
        filteredData = []
        for item in NetworkManager.shared.data {
            if item.title.lowercased().contains(searchText.lowercased()) {
                filteredData.append(item)
                if filteredData.count == 3 {
                    break
                }
            }
        }
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
            return filteredData.count
        } else {
            return NetworkManager.shared.data.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppsCollectionCell", for: indexPath) as! AppsCollectionViewCell
        let item: String
        let data = NetworkManager.shared.data
        if isFiltering() {
            item = filteredData[indexPath.item].title
        } else {
            item = data[indexPath.item].title
        }
        cell.AppLbl.text = item
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AppsListViewController(data: NetworkManager.shared.data[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
