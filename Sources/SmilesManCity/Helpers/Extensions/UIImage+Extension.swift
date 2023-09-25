//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 25/09/2023.
//

import UIKit
import SmilesUtilities

extension UIImage {
    
    convenience init?(name: String) {
        self.init(named: name, in: .module, compatibleWith: nil)
    }

    static let backIcon = UIImage(name: AppCommonMethods.languageIsArabic() ? "back_icon_ar" : "back_icon")
    
}
