//
//  Service.swift
//  TestApp
//
//  Created by Максим Байлюк on 06.05.2024.
//

import Foundation
import UIKit

class Service{
    static func createAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
            
        alert.addAction(okAction)
        
        return alert
    }
    static func createAlertController(title: String, message: String, completion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            // Execute the completion handler if provided
            completion?()
            alert.dismiss(animated: true, completion: nil)
        }
            
        alert.addAction(okAction)
        
        return alert
    }
    
}
