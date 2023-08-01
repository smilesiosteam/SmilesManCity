//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//

import Foundation
import SmilesSharedServices
import SmilesUtilities
import SmilesOffers
import SmilesStoriesManager

extension UpcomingMatchesViewModel {
    
    enum Input {
        case getSections(categoryID: Int)
        case getOffersCategoryList(pageNo: Int, categoryId: String, searchByLocation: Bool, sortingType: String?, subCategoryId: String = "1", subCategoryTypeIdsList: [String]?)
        case getTeamRankings
    }
    
    enum Output {
        case fetchSectionsDidSucceed(response: GetSectionsResponseModel)
        case fetchSectionsDidFail(error: Error)
        
        case fetchOffersCategoryListDidSucceed(response: OffersCategoryResponseModel)
        case fetchOffersCategoryListDidFail(error: Error)
        
        case fetchTeamRankingsDidSucceed(response: TeamRankingResponseModel)
        case fetchTeamRankingsDidFail(error: Error)
        
    }
    
}
