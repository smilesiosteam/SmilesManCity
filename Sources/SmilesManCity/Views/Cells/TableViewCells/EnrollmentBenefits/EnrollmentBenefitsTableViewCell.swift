//
//  EnrollmentBenefitsTableViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 26/06/2023.
//

import UIKit
import SmilesUtilities

class EnrollmentBenefitsTableViewCell: UITableViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var benefitLabel: UILabel!
    
    // MARK: - PROPERTIES -
    
    
    // MARK: - ACTIONS -
    
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(benefit: WhatYouGet) {
        
        iconImageView.setImageWithUrlString(benefit.iconURL ?? "")
        benefitLabel.text = benefit.text
        
    }
    
}
