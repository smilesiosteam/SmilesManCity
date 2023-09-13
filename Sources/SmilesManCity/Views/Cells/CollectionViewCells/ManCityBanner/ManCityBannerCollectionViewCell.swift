//
//  ManCityBannerCollectionViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 27/07/2023.
//

import UIKit
import SmilesUtilities

class ManCityBannerCollectionViewCell: UICollectionViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var updateImageView: UIImageView!
    
    // MARK: - PROPERTIES -
    
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with bannerImage: String) {
        self.updateImageView.setImageWithUrlString(bannerImage)
    }

}
