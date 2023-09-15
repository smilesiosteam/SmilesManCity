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
    func getTeamRankingsService(request: TeamRankingRequest) -> AnyPublisher<TeamRankingResponse, NetworkError>
    func getTeamNewsService(request: TeamNewsRequest) -> AnyPublisher<TeamNewsResponse, NetworkError>
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
  
    func getTeamRankingsService(request: TeamRankingRequest) -> AnyPublisher<TeamRankingResponse, NetworkError> {
        
        let endPoint = UpcomingMatchesRequestBuilder.getTeamRankings(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endPoint: .getTeamRankingInfo)
        return self.networkRequest.request(request)
        
    }
    
    func getTeamNewsService(request: TeamNewsRequest) -> AnyPublisher<TeamNewsResponse, NetworkingLayer.NetworkError> {
        
        let endPoint = UpcomingMatchesRequestBuilder.getTeamNews(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endPoint: .getTeamNewsInfo)
        return self.networkRequest.request(request)
        
    }
    
}
