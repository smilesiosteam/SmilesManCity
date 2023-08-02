//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 11/07/2023.
//

import Foundation
import NetworkingLayer
import SmilesUtilities
import SmilesBaseMainRequestManager

enum InviteFriendsDataRequestBuilder {
    
    
    case getInviteFriendsData(request: SmilesBaseMainRequest)
    
    
    var requestTimeOut: Int {
        return 20
    }
    
    
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getInviteFriendsData:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(baseUrl: String, endPoint: InviteFriendsDataEndPoints) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(baseUrl: baseUrl, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    
    var requestBody: Encodable? {
        switch self {
        case .getInviteFriendsData(let request):
            return request
        }
    }
    
    
    func getURL(baseUrl: String, for endPoint: InviteFriendsDataEndPoints) -> String {
        return baseUrl + endPoint.serviceEndPoints
    }
}

