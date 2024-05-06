//
//  MainTabBarController.swift
//  TestApp
//
//  Created by Максим Байлюк on 03.05.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        setTabBarAppearance()
        
    }
    
    private func setTabBar() {
        viewControllers = [generateNavVC(viewController: AppsViewController(), title: "Apps", image: UIImage(systemName: "square.fill.on.square.fill")), generateNavVC(viewController: GamesViewController(), title: "Games", image: UIImage(systemName: "gamecontroller")), generateNavVC(viewController: FavoritesViewController(), title: "Favorites", image: UIImage(systemName: "heart.fill")), generateNavVC(viewController: TopicsViewController(), title: "Topics", image: UIImage(systemName: "lineweight"))]
    }
    
    private func generateNavVC(viewController : UIViewController, title: String, image: UIImage?) -> UINavigationController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        viewController.title = title
        return UINavigationController(rootViewController: viewController)
    }
    
    private func setTabBarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundedLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minY - positionOnY, width: width, height: height), cornerRadius: height / 2)
        roundedLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundedLayer, at: 0)
        
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        let appearance = tabBar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        tabBar.standardAppearance = appearance;
        
        roundedLayer.fillColor = UIColor.mainBarColor.cgColor
        tabBar.tintColor = .tabBarItemAccent
        //tabBar.barTintColor = .mainBarColor
        tabBar.unselectedItemTintColor = .tabBarItemLight
        
    }
    

}
