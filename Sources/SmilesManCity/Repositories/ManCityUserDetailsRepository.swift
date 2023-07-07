//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 07/07/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities

protocol ManCityUserDetailsServiceable {
    func getPlayersService(request: ManCityPlayersRequest) -> AnyPublisher<ManCityPlayersResponse, NetworkError>
}

// GetCuisinesRepository
class ManCityUserDetailsRepository: ManCityUserDetailsServiceable {
    private var networkRequest: Requestable
    private var baseUrl: String

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
    }
    
    func getPlayersService(request: ManCityPlayersRequest) -> AnyPublisher<ManCityPlayersResponse, NetworkError> {
        
        let endPoint = ManCityUserDetailsRequestBuilder.getPlayersList(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl)
        return self.networkRequest.request(request)
        
    }
  
}
