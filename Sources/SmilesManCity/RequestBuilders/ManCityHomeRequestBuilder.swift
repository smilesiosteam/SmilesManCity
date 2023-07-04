//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import NetworkingLayer

enum ManCityHomeRequestBuilder {
    
    case getSubscriptionInfo(request: SubscriptionInfoRequest)
    
    // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    //specify the type of HTTP request
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getSubscriptionInfo:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(baseUrl: String, endPoint: ManCityHomeEndPoints) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(baseUrl: baseUrl, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .getSubscriptionInfo(let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(baseUrl: String, for endPoint: ManCityHomeEndPoints) -> String {
        return baseUrl + endPoint.serviceEndPoints
    }
}
