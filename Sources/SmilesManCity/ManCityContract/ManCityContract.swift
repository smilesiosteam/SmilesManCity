//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import Foundation
import SmilesSharedServices
import SmilesUtilities

extension ManCityHomeViewModel {
    
    enum Input {
        case getSections(categoryID: Int)
        case getSubscriptionInfo
        case getRewardPoints
        case getFAQsDetails(faqId: Int)
        case getPlayersList
    }
    
    enum Output {
        case fetchSectionsDidSucceed(response: GetSectionsResponseModel)
        case fetchSectionsDidFail(error: Error)
        
        case fetchSubscriptionInfoDidSucceed(response: SubscriptionInfoResponse)
        case fetchSubscriptionInfoDidFail(error: Error)
        
        case fetchRewardPointsDidSucceed(response: RewardPointsResponseModel, shouldLogout: Bool?)
        case fetchRewardPointsDidFail(error: Error)
        
        case fetchFAQsDidSucceed(response: FAQsDetailsResponse)
        case fetchFAQsDidFail(error: Error)
        
        case fetchPlayersDidSucceed(response: ManCityPlayersResponse)
        case fetchPlayersDidFail(error: Error)
    }
    
}
