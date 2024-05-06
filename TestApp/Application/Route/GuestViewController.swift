//
//  HomeViewController.swift
//  TestApp
//
//  Created by Максим Байлюк on 03.05.2024.
//

import UIKit
import SwiftyDropbox

class GuestViewController: UIViewController {

    @IBOutlet weak var SignInBtn: UIButton!
    @IBOutlet weak var SignInWarningLbl: UILabel!
    
    static let shared = GuestViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - UI
    func configureUI() {
        //Set Tab Bar
        let tabBar = MainTabBarController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(vc: tabBar)
    }
    
    //MARK: - Dropbox Auth
    @IBAction func SignInTapped(_ sender: UIButton) {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["files.content.read", "account_info.read"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: self,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
    
}
