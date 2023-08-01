//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

class TeamRankingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - OUTLETS -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var prefixLbl: UILabel!
    
    // MARK: - METHODS -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        mainView.backgroundColor = .clear
        title.fontTextStyle = .smilesTitle2
        prefixLbl.fontTextStyle = .smilesBody4
        title.textColor = .appRevampCollectionsTitleColor
    }
    
    func configureCell(with ranking: TeamRanking) {
        if let url = ranking.iconUrl, !url.isEmpty {
            iconImageView.isHidden = false
            iconImageView.setImageWithUrlString(url, backgroundColor: .clear) { image in
                if let image {
                    self.iconImageView.image = image
                }
            }
        } else {
            iconImageView.isHidden = true
        }
        prefixLbl.text = ranking.text
        title.text = ranking.text
        title.isHidden = iconImageView.isHidden
    }
}
