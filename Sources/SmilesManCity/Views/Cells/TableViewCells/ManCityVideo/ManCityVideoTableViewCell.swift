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
        let youtubeId = AppCommonMethods.extractYoutubeId(fromLink: videoUrl ?? "")
        self.thumbnailImageView.setImageWithUrlString(youtubeId, backgroundColor: .systemGray5) { image in
            if let image {
                self.thumbnailImageView.image = image
            }
        }
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
    }
}
