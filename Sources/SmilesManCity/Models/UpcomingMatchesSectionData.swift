//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import Foundation

enum UpcomingMatchesSectionIdentifier: String {
    
    case topPlaceholder = "TOP_PLACEHOLDER"
    case offerListing = "OFFER_LISTING2"
    case teamRankings = "OFFER_LISTING"
    
}

struct UpcomingMatchesSectionData {
    
    let index: Int
    let identifier: UpcomingMatchesSectionIdentifier
    
}
