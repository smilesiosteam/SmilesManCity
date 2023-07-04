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
    
    var extTransactionID: String?
    var themeResources: ThemeResources?
    var isCustomerElgibile: Bool?
    var lifestyleOffers: [BOGODetailsResponseLifestyleOffer]?

    enum CodingKeys: String, CodingKey {
        case extTransactionID = "extTransactionId"
        case themeResources, isCustomerElgibile, lifestyleOffers
    }

}

class ThemeResources: Codable {
    
    var mancityImageURL: String?
    var welcomeTitle, welcomeSubTitle, mancitySubBgColor, mancitySubButtonText, mancitySubBgColorDirection: String?

    enum CodingKeys: String, CodingKey {
        case mancityImageURL = "mancityImageUrl"
        case welcomeTitle, welcomeSubTitle, mancitySubBgColor, mancitySubButtonText, mancitySubBgColorDirection
    }
    
}
