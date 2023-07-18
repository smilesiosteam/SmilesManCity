//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 04/07/2023.
//

import Foundation
import SmilesUtilities
import NetworkingLayer

class SubscriptionInfoResponse: BaseMainResponse {
    
    var themeResources: ThemeResources?
    var isCustomerElgibile: Bool?
    var lifestyleOffers: [BOGODetailsResponseLifestyleOffer]?

    enum CodingKeys: String, CodingKey {
        case themeResources, isCustomerElgibile, lifestyleOffers
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        themeResources = try values.decodeIfPresent(ThemeResources.self, forKey: .themeResources)
        isCustomerElgibile = try values.decodeIfPresent(Bool.self, forKey: .isCustomerElgibile)
        lifestyleOffers = try values.decodeIfPresent([BOGODetailsResponseLifestyleOffer].self, forKey: .lifestyleOffers)
        try super.init(from: decoder)
    }
    
}

public class ThemeResources: Codable {
    
    var mancityImageURL: String?
    var welcomeTitle, welcomeSubTitle, mancitySubBgColor, mancitySubButtonText, mancitySubBgColorDirection: String?

    enum CodingKeys: String, CodingKey {
        case mancityImageURL = "mancityImageUrl"
        case welcomeTitle, welcomeSubTitle, mancitySubBgColor, mancitySubButtonText, mancitySubBgColorDirection
    }
    
}
