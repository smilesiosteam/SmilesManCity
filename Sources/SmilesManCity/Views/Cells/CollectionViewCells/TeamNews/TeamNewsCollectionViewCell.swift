//
//  TeamNewsCollectionViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/09/2023.
//

import UIKit
import SmilesUtilities

class TeamNewsCollectionViewCell: UICollectionViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    // MARK: - PROPERTIES -
    
    
    // MARK: - ACTIONS -
    
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        
        newsImageView.layer.cornerRadius = 8
        newsImageView.contentMode = .scaleAspectFill
        descriptionLabel.numberOfLines = 3
        if AppCommonMethods.languageIsArabic() {
            contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
    }
    
    func setupData(news: TeamNews) {
        
        newsImageView.setImageWithUrlString(news.imageURL ?? "")
        titleLabel.text = news.title
        descriptionLabel.text = news.description
        
    }

}
