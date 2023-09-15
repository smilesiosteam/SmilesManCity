//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 13/09/2023.
//

import Foundation

enum UpcomingMatchesEndPoints: String, CaseIterable {
    case getTeamRankingInfo
    case getTeamNewsInfo
}

extension UpcomingMatchesEndPoints {
    var serviceEndPoints: String {
        switch self {
        case .getTeamRankingInfo:
            return "mancity/team-rankings"
        case .getTeamNewsInfo:
            return "mancity/team-news"
        }
    }
}
