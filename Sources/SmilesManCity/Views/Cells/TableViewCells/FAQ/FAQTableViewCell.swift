//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 05/07/2023.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS -
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dropdownImageView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var textContent: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell() {
        // TODO: Populate data here
    }
}
