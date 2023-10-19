//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import Foundation
import SmilesUtilities

enum ManCityHomeSectionIdentifier: String, SectionIdentifierProtocol {
    
    var identifier: String { return self.rawValue}
    
    case topPlaceholder = "TOP_PLACEHOLDER"
    case quickAccess = "QUICK_ACCESS"
    case offerListing = "OFFER_LISTING"
    case about = "ABOUT"
    case inviteFriends = "INVITE_FRIEND"
    case enrollment = "ENROLLMENT"
    case FAQS
    case updates = "UPDATES"
    
}

enum ManCityMerchStoreSectionIdentifier: String, SectionIdentifierProtocol {
    
    var identifier: String { return self.rawValue}
    case offerListing = "OFFER_LISTING"
    
}
