//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//
//

import Foundation
import NetworkingLayer
import SmilesUtilities
import SmilesOffers

enum UpcomingMatchesRequestBuilder {
    
    case getTeamRankings(request: TeamRankingRequest)
    
    var requestTimeOut: Int {
        return 20
    }
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getTeamRankings:
            return .POST
        }
    }
    func createRequest(baseUrl: String, endPoint: UpcomingMatchesEndPoints) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(baseUrl: baseUrl, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    var requestBody: Encodable? {
        switch self {
        case .getTeamRankings(let request):
            return request
        }
    }
    
    func getURL(baseUrl: String, for endPoint: UpcomingMatchesEndPoints) -> String {
        return baseUrl + endPoint.serviceEndPoints
    }
}

