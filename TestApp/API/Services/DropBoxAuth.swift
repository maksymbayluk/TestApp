//
//  DropBoxAuth.swift
//  TestApp
//
//  Created by Максим Байлюк on 06.05.2024.
//

import Foundation
import UIKit
import SafariServices


class DropBoxAuth: UIViewController, SFSafariViewControllerDelegate {
    
    static func logout(completion: @escaping () -> Void) {
        // Simulate logout process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Perform logout action here
            // For example, you can clear user session, reset authentication tokens, etc.
            print("Logged out from Dropbox")
            
            // Call completion handler after logout process
            completion()
        }
    }
    
    static func presentDropboxLogout(from viewController: UIViewController, completion: (() -> Void)? = nil) {
        let dropboxLogoutURL = URL(string: "https://www.dropbox.com/logout")!
        let safariViewController = SFSafariViewController(url: dropboxLogoutURL)
        safariViewController.delegate = viewController as? SFSafariViewControllerDelegate
        viewController.present(safariViewController, animated: true, completion: completion)
    }
    
    static func safariViewControllerDidFinish(_ controller: SFSafariViewController, completion: @escaping () -> Void) {
        controller.dismiss(animated: true) {
            // Call logout function after the SafariViewController is dismissed
            DropBoxAuth.logout {
                // Additional actions after logout
                print("Logout process completed. Now performing additional actions.")
                // Perform other settings or navigation
                completion()
            }
        }
    }
}
