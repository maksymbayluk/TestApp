//
//  FavoritesViewController.swift
//  TestApp
//
//  Created by Максим Байлюк on 04.05.2024.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var FavoritesTV: UITableView!
    var apps: [FavoriteApp] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTV()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getFavoriteApps()
    }
    //MARK: - INTERNET CHECK
    @objc func nointernet(notification: NSNotification) {
        //show animation no internet
        print("no internet in favorites")
    }
    @objc func internet(notification: NSNotification) {
        //show animation no internet
        print("internet in apps")
        
    }
    
    //MARK: - TABLE VIEW UI

    func configureTV() {
        FavoritesTV.delegate = self
        FavoritesTV.dataSource = self
        FavoritesTV.separatorStyle = .none
        FavoritesTV.rowHeight = 80
        FavoritesTV.estimatedRowHeight = UITableView.automaticDimension
        FavoritesTV.isUserInteractionEnabled = true
        let nib = UINib(nibName: "FavoritesTableViewCell", bundle: nil)
        FavoritesTV.register(nib, forCellReuseIdentifier: "FavoritesTVCell")
        
    }
    //MARK: - DATA FROM COREDATA
    func getFavoriteApps() {
        CoreDataTaskManager.shared.fetchFavorites { favoriteApps, error in
            if let favoriteApps = favoriteApps {
                self.apps = favoriteApps
                self.FavoritesTV.reloadData()
            }
            
        }
        
    }
    func CoreDataToModel(cd: FavoriteApp) -> AppModel {
        return AppModel(title: cd.title ?? "", image_url: cd.image_url ?? "", description: cd.descrip ?? "")
    }
}
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTVCell", for: indexPath) as! FavoritesTableViewCell
        cell.AppTitleLbl.text = apps[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FavoritesTV.deselectRow(at: indexPath, animated: true)
        
        let vc = AppDetailViewController(data: CoreDataToModel(cd: apps[indexPath.row]), categoryTitle: apps[indexPath.row].categoryTitle!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        FavoritesTV.deselectRow(at: indexPath, animated: true)
    }
    
    
}
