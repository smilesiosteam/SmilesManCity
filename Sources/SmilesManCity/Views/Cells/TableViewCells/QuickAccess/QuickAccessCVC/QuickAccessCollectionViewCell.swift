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
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    // MARK: - METHODS -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        title.font = SmilesFonts.circular.getFont(style: .medium, size: 12.0)
        title.textColor = .appRevampCollectionsTitleColor
    }
}
