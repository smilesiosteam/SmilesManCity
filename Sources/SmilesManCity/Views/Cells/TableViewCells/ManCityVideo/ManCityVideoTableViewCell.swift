//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 05/07/2023.
//

import UIKit
import SmilesUtilities

class ManCityVideoTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - METHODS -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(videoUrl: String?) {
        let thumbnailUrl = AppCommonMethods.extractThumbnailFromYoutube(url: videoUrl ?? "")
        self.thumbnailImageView.setImageWithUrlString(thumbnailUrl) { image in
            if let image {
                self.thumbnailImageView.image = image
            }
        }
    }
}
