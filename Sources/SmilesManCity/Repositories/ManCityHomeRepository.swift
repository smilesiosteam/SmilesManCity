//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities

protocol ManCityHomeServiceable {
    func getSubscriptionInfoService(request: SubscriptionInfoRequest) -> AnyPublisher<SubscriptionInfoResponse, NetworkError>
}

// GetCuisinesRepository
class ManCityHomeRepository: ManCityHomeServiceable {
    private var networkRequest: Requestable
    private var baseUrl: String
    private var endPoint: ManCityHomeEndPoints

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String, endPoint: ManCityHomeEndPoints) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
        self.endPoint = endPoint
    }
    
    func getSubscriptionInfoService(request: SubscriptionInfoRequest) -> AnyPublisher<SubscriptionInfoResponse, NetworkError> {
        
        let endPoint = ManCityHomeRequestBuilder.getSubscriptionInfo(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endPoint: .getSubscriptionInfo)
        return self.networkRequest.request(request)
        
    }
  
}
