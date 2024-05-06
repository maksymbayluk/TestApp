//
//  AppsListVCViewController.swift
//  TestApp
//
//  Created by Максим Байлюк on 05.05.2024.
//

import UIKit

class AppsListViewController: UIViewController {
    

    @IBOutlet weak var AppsTableView: UITableView!
    @IBOutlet weak var NoAppsWarningLbl: UILabel!
    
    var category: AppCategoryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAppsAvailability()
        configureTV()
        self.tabBarController?.tabBar.isHidden = true
        title = category?.title
    }
    init(data: AppCategoryModel) {
        self.category = data
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTV() {
        AppsTableView.delegate = self
        AppsTableView.dataSource = self
        AppsTableView.separatorStyle = .none
        AppsTableView.backgroundColor = .systemBackground
        AppsTableView.rowHeight = 80
        AppsTableView.estimatedRowHeight = UITableView.automaticDimension
        AppsTableView.isUserInteractionEnabled = true
        let nib = UINib(nibName: "AppsListTVC", bundle: nil)
        AppsTableView.register(nib, forCellReuseIdentifier: "AppsListTVC")
    }
    
    func checkAppsAvailability() {
        if category?.apps.count == 0 {
            NoAppsWarningLbl.alpha = 1
        } else {
            NoAppsWarningLbl.alpha = 0
        }
    }
    


//MARK: - TABLE VIEW DELEGATE AND DATASOURCE
}
extension AppsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.apps.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppsListTVC", for: indexPath) as! AppsListTVC
        if let category = category {
            cell.AppTitleLbl.text = category.apps[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppsTableView.deselectRow(at: indexPath, animated: true)
        let vc = AppDetailViewController(data: category!.apps[indexPath.row], categoryTitle: category!.title)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        AppsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
