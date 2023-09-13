//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import Foundation

enum UpcomingMatchesSectionIdentifier: String {
    
    case teamRankings = "TEAM_RANKINGS"
    case teamNews = "TEAM_NEWS"
    
}

struct UpcomingMatchesSectionData {
    
    let index: Int
    let identifier: UpcomingMatchesSectionIdentifier
    
}
