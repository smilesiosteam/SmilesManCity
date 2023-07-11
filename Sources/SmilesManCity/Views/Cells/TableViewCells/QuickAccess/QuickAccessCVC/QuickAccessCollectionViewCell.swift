//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 05/07/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

class QuickAccessCollectionViewCell: UICollectionViewCell {
    
    // MARK: - OUTLETS -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    // MARK: - METHODS -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        mainView.backgroundColor = .appRevampFilterCountBGColor.withAlphaComponent(0.2)
        mainView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 8.0)
        
        title.fontTextStyle = .smilesTitle3
        title.textColor = .appRevampCollectionsTitleColor
    }
    
    func configureCell(with quickAccessLink: QuickAccessLink) {
        iconImageView.setImageWithUrlString(quickAccessLink.linkIconUrl ?? "") { image in
            if let image {
                self.iconImageView.image = image
            }
        }
        
        title.text = quickAccessLink.linkText
    }
}
