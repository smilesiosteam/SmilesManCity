//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 11/07/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesOffers
import SmilesBaseMainRequestManager

protocol InviteFriendsServiceable {
    func InviteFriendsService(request: SmilesBaseMainRequest) -> AnyPublisher<InviteFriendsResponse, NetworkError>
}

class InviteFriendsRepository: InviteFriendsServiceable {
    
    private var networkRequest: Requestable
    private var baseUrl: String
    private var endPoint: InviteFriendsDataEndPoints

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String, endPoint: InviteFriendsDataEndPoints) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
        self.endPoint = endPoint
    }
  
    func InviteFriendsService(request: SmilesBaseMainRequest) -> AnyPublisher<InviteFriendsResponse, NetworkError> {
        let endPoint = InviteFriendsDataRequestBuilder.getInviteFriendsData(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endPoint: .fetchInviteFriendsData)
        
        return self.networkRequest.request(request)
    }
}
