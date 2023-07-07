//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 05/07/2023.
//

import UIKit
import SmilesSharedServices
import SmilesUtilities
import SmilesFontsManager

class FAQTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS -
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dropdownImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.isHidden = true
        }
    }
    
    // MARK: - LIFECYCLE -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(faqDetail: FaqsDetail) {
        
        titleLabel.text = faqDetail.faqTitle
        descriptionLabel.attributedText(faqDetail.faqContent.asStringOrEmpty().htmlToAttributedString, style: .smilesBody2,
                                        alignment: AppCommonMethods.languageIsArabic() ? .right : .left)
        dropdownImageView.image = UIImage(named: (faqDetail.isHidden ?? true) ? "faq_dropdown" : "faq_collapse", in: .module, compatibleWith: nil)
        titleLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        
    }
}
