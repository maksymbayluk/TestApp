//
//  NetworkManager.swift
//  TestApp
//
//  Created by Максим Байлюк on 03.05.2024.
//

import Foundation
import SwiftyDropbox


class NetworkManager {
    static let shared = NetworkManager()
    public var data: [AppCategoryModel] = []
    
    private init() {}
    
    func fetchImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let client = DropboxClientsManager.authorizedClient
        client!.files.download(path: path)
            .response { response, error in
                if let response = response {
                    let fileContents = response.1
                    completion(fileContents, nil) // Pass image data to completion handler
                } else if let error = error {
                    completion(nil, error) // Pass error to completion handler
                }
            }
            .progress { progressData in
                
        }
    }
        

    func fetchData(completion: @escaping ([AppCategoryModel]?, Error?) -> Void) {
        let client = DropboxClientsManager.authorizedClient
        client!.files.download(path: "/data.json")
            .response { response, error in
                if let response = response {
                    let fileContents = response.1
                    do {
                        let decodedData = try JSONDecoder().decode([AppCategoryModel].self, from: fileContents)
                        completion(decodedData, nil)
                    } catch {
                        completion(nil, error)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
            .progress { progressData in
                
            }
    }

}
