//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/08/2023.
//

import Foundation
import SmilesOffers

public protocol ManCityHomeDelegate: AnyObject {
    
    func proceedToPayment(params: ManCityPaymentParams)
    func proceedToOfferDetails(offer: OfferDO?)
    func handleDeepLinkRedirection(redirectionUrl: String)
    
}
