//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 19/07/2023.
//

import Foundation
import SmilesUtilities

public struct ManCityPaymentParams {
    
    public var lifeStyleOffer: BOGODetailsResponseLifestyleOffer
    public var playerID: String
    public var referralCode: String
    public var hasAttendedManCityGame: Bool
    public var appliedPromoCode: BOGOPromoCode?
    public var priceAfterPromo: Double?
    public var themeResources: ThemeResources?
    public var isComingFromSpecialOffer: Bool
    public var isComingFromTreasureChest: Bool
    
}
