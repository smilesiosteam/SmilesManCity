//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesOffers

protocol UpcomingMatchesServiceable {
    func getTeamRankingsService(request: TeamRankingRequest) -> AnyPublisher<TeamRankingResponseModel, NetworkError>
}

class UpcomingMatchesRepository: UpcomingMatchesServiceable {
    
    private var networkRequest: Requestable
    private var baseUrl: String
    private var endPoint: UpcomingMatchesEndPoints

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String, endPoint: UpcomingMatchesEndPoints) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
        self.endPoint = endPoint
    }
  
    func getTeamRankingsService(request: TeamRankingRequest) -> AnyPublisher<TeamRankingResponseModel, NetworkError> {
        
        let endPoint = UpcomingMatchesRequestBuilder.getTeamRankings(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endPoint: .getTeamRankingInfo)
        return self.networkRequest.request(request)
        
    }
}
