//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/09/2023.
//

import Foundation

class TeamNewsResponse: Codable {
    let teamNews: [TeamNews]?
    
    enum CodingKeys: String, CodingKey {
        case teamNews = "TeamNews"
    }
    
    init(teamNews: [TeamNews]?) {
        self.teamNews = teamNews
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
