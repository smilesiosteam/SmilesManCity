//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import Foundation

enum ManCitySectionIdentifier: String {
    
    case topPlaceholder = "TOP_PLACEHOLDER"
    case quickAccess = "QUICK_ACCESS"
    case offerListing = "OFFER_LISTING"
    case about = "ABOUT"
    case inviteFriends = "INVITE_FRIEND"
    case enrollment = "ENROLLMENT"
    case FAQS
    
}

struct ManCitySectionData {
    
    let index: Int
    let identifier: ManCitySectionIdentifier
    
}
