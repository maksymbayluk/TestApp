//
//  NoInternetVC.swift
//  TestApp
//
//  Created by Максим Байлюк on 06.05.2024.
//

import UIKit

class NoInternetVC: UIViewController {

    @IBOutlet weak var reloadView: UIView!
    private var isCheckingConnection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reloadInternet(_:)))
        reloadView.addGestureRecognizer(tapGesture)

    }
    
    @objc func reloadInternet(_ sender: UITapGestureRecognizer) {
        guard !isCheckingConnection else { return }
        Reachability.shared.checkInternetConnection { isConnected in
            if isConnected {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "internetcheckOK"),
                                            object: nil)
            } else {
                // Handle accordingly
            }
            self.isCheckingConnection = false
        }
        
    }
}
