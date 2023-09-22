//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 05/07/2023.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager

class ManCityHeader: UIView {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var titleLabel: UILocalizableLabel!
    @IBOutlet weak var subTitleLabel: UILocalizableLabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewAllContainer: UIView!
    @IBOutlet weak var viewAllLabel: UILocalizableLabel!
    
    // MARK: - PROPERTIES -
    var viewAllPressed: (() -> Void)?
    
    // MARK: - ACTIONS -
    @IBAction func viewAllPressed(_ sender: Any) {
        viewAllPressed?()
    }
    
    // MARK: - METHODS -
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("ManCityHeader", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = bounds
        mainView.bindFrameToSuperviewBounds()
    }
    
    func setupData(title: String?, subTitle: String?, color: UIColor?, showViewAllButton: Bool = false) {
        titleLabel.localizedString = title ?? ""
        subTitleLabel.localizedString = subTitle ?? ""
        if let color {
            mainView.backgroundColor = color
        } else {
            mainView.backgroundColor = .white
        }
        subTitleLabel.isHidden = subTitle == nil
        titleLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        subTitleLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        viewAllContainer.isHidden = !showViewAllButton
        viewAllLabel.textAlignment = AppCommonMethods.languageIsArabic() ? .left : .right
    }
    
}
