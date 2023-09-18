//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/09/2023.
//

import Foundation
import NetworkingLayer

class TeamNewsResponse: BaseMainResponse {
    let teamNews: [TeamNews]?
    
    enum CodingKeys: String, CodingKey {
        case teamNews
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        teamNews = try values.decodeIfPresent([TeamNews].self, forKey: .teamNews)
        try super.init(from: decoder)
    }
    
}

class TeamNews: Codable {
    let id, title, description: String?
    let redirectionURL: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case description = "Description"
        case redirectionURL = "redirectionUrl"
        case imageURL = "imageUrl"
    }
    
    init(id: String?, title: String?, description: String?, redirectionURL: String?, imageURL: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.redirectionURL = redirectionURL
        self.imageURL = imageURL
    }
}
