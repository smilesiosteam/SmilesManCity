//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import Foundation
import SmilesSectionsManager

extension ManCityHomeViewModel {
    
    enum Input {
        case getSections(categoryID: Int)
        case getSubscriptionInfo
    }
    
    enum Output {
        case fetchSectionsDidSucceed(response: GetSectionsResponseModel)
        case fetchSectionsDidFail(error: Error)
        
        case fetchSubscriptionInfoDisSucceed
    }
    
}
