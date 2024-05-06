//
//  SceneDelegate.swift
//  TestApp
//
//  Created by Максим Байлюк on 03.05.2024.
//

import UIKit
import SwiftyDropbox
import Network


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    static let shared = SceneDelegate()
//    let authManager = DropboxOAuthManager(appKey: "4y2x12wkxjr85kp", secureStorageAccess: "7akkuar2jmcpwhq" as! SecureStorageAccess)
//    let refreshToken = "Tte_JUzfmDMAAAAAAAAAAUi7TPB57Pq8EX937LhV6zrUFqDgmngdBi-z6GaKxZ5h"

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        //MARK: - Create a new window and set the root view controller
        
        if DropboxClientsManager.authorizedClient != nil {
            let viewController = MainTabBarController()
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        } else {
            let viewController = GuestViewController()
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }
        
    }
    func changeRootVC(vc: UIViewController) {
        guard let window = window  else  { return }
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil)
        
    }
    
    //MARK: - DROPBOX AUTH
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
         let oauthCompletion: DropboxOAuthCompletion = {
          if let authResult = $0 {
              switch authResult {
              case .success:
                  (self.window?.rootViewController as! GuestViewController).configureUI()
              case .cancel:
                  print("Authorization flow was manually canceled by user!")
              case .error(_, let description):
                  print("Error: \(String(describing: description))")
              }
          }
        }

        for context in URLContexts {
            // stop iterating after the first handle-able url
            if DropboxClientsManager.handleRedirectURL(context.url, includeBackgroundClient: false, completion: oauthCompletion) { break }
        }
    }
    //MARK: - INTERNET CHECK
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
        Reachability.shared.IsNetworkAvailable()
        
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
