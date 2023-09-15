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
        case getTeamRankings
        case getTemNews
    }
    
    enum Output {
        case fetchSectionsDidSucceed(response: GetSectionsResponseModel)
        case fetchSectionsDidFail(error: Error)
        
        case fetchTeamRankingsDidSucceed(response: TeamRankingResponse)
        case fetchTeamRankingsDidFail(error: Error)
        
        case fetchTeamNewsDidSucceed(response: TeamNewsResponse)
        case fetchTeamNewsDidFail(error: Error)
        
    }
    
}
