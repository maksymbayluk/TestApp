//
//  CoreDataTaskManager.swift
//  TestApp
//
//  Created by Максим Байлюк on 05.05.2024.
//

import Foundation
import CoreData
import UIKit

class CoreDataTaskManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let shared = CoreDataTaskManager()
    var favoriteApps: [FavoriteApp]?
    var app: [FavoriteApp]?
    
    //MARK: - CORE DATA REQUESTS
    
    func addToFavorite(data: AppModel, title: String) {
        let app = FavoriteApp(context: self.context)
        app.title = data.title
        app.descrip = data.description
        app.image_url = data.image_url
        app.categoryTitle = title
        do {
            print("saved")
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    func fetchFavorites(completion: @escaping ([FavoriteApp]?, Error?) -> Void) {
        do {
            let favoriteApps = try context.fetch(FavoriteApp.fetchRequest()) as? [FavoriteApp]
            completion(favoriteApps, nil)
        } catch {
            completion(nil, error)
        }
    }
    func fetchApp(title: String) -> FavoriteApp? {
        do {
            let request = FavoriteApp.fetchRequest() as NSFetchRequest<FavoriteApp>
            let pred = NSPredicate(format: "title == %@", title)
            //can filter by other paramets like id, it is just an example
            request.predicate = pred
            self.app = try context.fetch(request)
            if self.app != nil {
                return self.app?.first
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
        
    }
    
    func removeFromFavorite(data: FavoriteApp) {
        self.context.delete(data)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    func numberOfSavedItems() -> Int {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteApp.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("Error counting saved items: \(error)")
            return 0
        }
    }
    
}

