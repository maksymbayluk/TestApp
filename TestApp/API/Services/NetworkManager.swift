//
//  NetworkManager.swift
//  TestApp
//
//  Created by Максим Байлюк on 03.05.2024.
//

import Foundation
import SwiftyDropbox

protocol NetworkUIUpdateDelegate {
    func updateUI()
}

class NetworkManager {
    static let shared = NetworkManager()
    public var data: [AppCategoryModel] = []
    
    private init() {
        self.delegate = AppsViewController()
    }
    
    var delegate: NetworkUIUpdateDelegate?
    
    func fetchImage(path: String) {
        let client = DropboxClientsManager.authorizedClient
        client!.files.download(path: path)
            .response { response, error in
                if let response = response {
                    let responseMetadata = response.0
                    print(responseMetadata)
                    let fileContents = response.1
                    print(fileContents)
                } else if let error = error {
                    print(error)
                }
            }
            .progress { progressData in
                print(progressData)
            }
        
        //download image inside file system and show share menu via protocols
       
    }
    func fetchData() {
        let client = DropboxClientsManager.authorizedClient
        client!.files.download(path: "/data.json")
            .response { response, error in
                if let response = response {
                    let fileContents = response.1
                    do {
                        self.data = try JSONDecoder().decode([AppCategoryModel].self, from: fileContents)
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.delegate?.updateUI()
                } else if let error = error {
                    print(error)
                    //do alert
                }
            }
            .progress { progressData in
                print(progressData)
            }
    }

}
