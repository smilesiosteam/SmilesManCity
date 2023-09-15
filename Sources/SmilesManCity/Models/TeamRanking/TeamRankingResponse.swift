//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//

import Foundation
import NetworkingLayer

struct TeamRankingRowData {
    var rankings: [TeamRankingColumnData] = []
}

struct TeamRankingColumnData {
    var text: String?
    var iconUrl: String?
}

class TeamRankingResponse: BaseMainResponse {
    
    var teamRankings: [TeamRanking]?
    
    enum CodingKeys: String, CodingKey {
        case teamRankings
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        teamRankings = try values.decodeIfPresent([TeamRanking].self, forKey: .teamRankings)
        try super.init(from: decoder)
    }
    
}

class TeamRanking: Codable {
    
    var teamID: Int?
    var imageURL: String?
    var teamName: String?
    var played, won, drawn, lost: Int?
    var goalDifference: String?
    var points, position: Int?

    enum CodingKeys: String, CodingKey {
        case teamID
        case imageURL = "imageUrl"
        case teamName, played, won, drawn, lost, goalDifference, points, position
    }

}
