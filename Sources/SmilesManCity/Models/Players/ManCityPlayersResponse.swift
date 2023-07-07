//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 07/07/2023.
//

import Foundation
import NetworkingLayer

class ManCityPlayersResponse: BaseMainResponse {
    
    var players: [ManCityPlayer]?

    enum CodingKeys: String, CodingKey {
        case players
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        players = try values.decodeIfPresent([ManCityPlayer].self, forKey: .players)
        try super.init(from: decoder)
    }
    
}

// MARK: - Player
class ManCityPlayer: Codable {
    
    var playerID, playerName: String?

    enum CodingKeys: String, CodingKey {
        case playerID = "playerId"
        case playerName
    }
    
}
