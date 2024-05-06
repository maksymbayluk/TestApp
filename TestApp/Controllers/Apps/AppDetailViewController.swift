//
//  AppDetailViewController.swift
//  TestApp
//
//  Created by Максим Байлюк on 05.05.2024.
//

import UIKit

class AppDetailViewController: UIViewController {

    var app: AppModel?
    var categoryTitle: String
    var favorite: FavoriteApp?
   
    @IBOutlet weak var AppImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var AddToFavoriteBnt: UIButton!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setButtonAppearance()
        checkIfImageDownloaded()
    }
    init(data: AppModel, categoryTitle: String) {
        self.app = data
        self.categoryTitle = categoryTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI
    
    func setUpUI()  {
        title = categoryTitle
        titleLbl.text = app?.title
        descriptionLbl.text = app?.description
        title = categoryTitle
        AppImage.layer.masksToBounds = false
        AppImage.image = AppImage.image?.withRoundedCorners(radius: 8)
        AppImage.layer.shadowRadius = 3
        AppImage.layer.shadowColor = UIColor.black.cgColor
        AppImage.layer.shadowOpacity = 0.5
        AppImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down.fill"), style: .plain, target: self, action: #selector(downloadImage))

    }
    func IsFavorite() -> Bool {
        favorite = CoreDataTaskManager.shared.fetchApp(title: app!.title)
        if favorite != nil {
            return true
        } else {
            return false
        }
    }
    func checkIfImageDownloaded() {
        if let cachedImage = ImageManager.shared.getImage(forKey: app!.image_url) {
            DispatchQueue.main.async { [self] in
                self.AppImage.image = cachedImage
                openShareMenu(with: self.AppImage.image!)
            }
        } else {
            setImage()
        }
        
    }
    func setImage() {
        ActivityIndicator.alpha = 1
        ActivityIndicator.startAnimating()
        NetworkManager.shared.fetchImage(path: app!.image_url) { imageData, error in
            if let imageData = imageData {
                DispatchQueue.main.async {
                    self.ActivityIndicator.stopAnimating()
                    self.ActivityIndicator.alpha = 0
                    self.AppImage.image = UIImage(data: imageData)
                }
            } else if error != nil {
                self.ActivityIndicator.stopAnimating()
                self.ActivityIndicator.alpha = 0
                self.showErrorAlert(message: "Cannot download image for you")
            }
        }
    }
    func setButtonAppearance() {
        if IsFavorite() {
            AddToFavoriteBnt.setTitle("Remove from favorite", for: .normal)
            AddToFavoriteBnt.tintColor = .lightGray
        } else {
            AddToFavoriteBnt.setTitle("Add to favorite", for: .normal)
            AddToFavoriteBnt.tintColor = .blue
        }
    }
    
    //MARK: - ACTION
   
    @IBAction func AddToFavorites(_ sender: UIButton) {
        HapticManager.shared.impact(style: .medium)
        if IsFavorite() {
            CoreDataTaskManager.shared.removeFromFavorite(data: favorite!)
        } else {
            CoreDataTaskManager.shared.addToFavorite(data: app!, title: categoryTitle)
        }
        setButtonAppearance()
    }
    
    @objc func downloadImage() {
        HapticManager.shared.impact(style: .medium)
        NetworkManager.shared.fetchImage(path: app!.image_url) { [self] imageData, error in
            if let imageData = imageData {
                // Use the downloaded image data
                DispatchQueue.main.async { [self] in
                    self.AppImage.image = UIImage(data: imageData)
                    ImageManager.shared.saveImage(self.AppImage.image!, forKey: app!.image_url)
                    openShareMenu(with: self.AppImage.image!)
                }
            } else if error != nil {
                showErrorAlert(message: "Cannot download image for you")
            }
        }
        
    }
    func openShareMenu(with image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // For iPad compatibility
        self.present(activityViewController, animated: true, completion: nil)
    }
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    

}
