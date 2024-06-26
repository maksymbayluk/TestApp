//
//  AppModel.swift
//  TestApp
//
//  Created by Максим Байлюк on 04.05.2024.
//

import Foundation

struct AppCategoryModel: Decodable {
    let title: String
    let apps: [AppModel]
}


struct AppModel: Decodable {
    let title: String
    let image_url: String
    let description: String
}


