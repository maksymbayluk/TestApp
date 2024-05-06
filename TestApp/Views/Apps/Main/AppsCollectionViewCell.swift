//
//  AppsCollectionViewCell.swift
//  TestApp
//
//  Created by Максим Байлюк on 04.05.2024.
//

import UIKit

class AppsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var AppLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
    }

}
