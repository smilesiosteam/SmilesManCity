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
    func getOffersCategoryListService(request: OffersCategoryRequestModel) -> AnyPublisher<OffersCategoryResponseModel, NetworkError>
}

class UpcomingMatchesRepository: UpcomingMatchesServiceable {
    
    private var networkRequest: Requestable
    private var baseUrl: String
    private var endPoint: ManCityHomeEndPoints

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String, endPoint: ManCityHomeEndPoints) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
        self.endPoint = endPoint
    }
  
    func getOffersCategoryListService(request: OffersCategoryRequestModel) -> AnyPublisher<OffersCategoryResponseModel, NetworkError> {
        let endPoint = UpcomingMatchesRequestBuilder.getOffersCategoryList(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endPoint: .offersCategoryList)
        
        return self.networkRequest.request(request)
    }
}
