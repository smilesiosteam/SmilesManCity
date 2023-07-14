//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 11/07/2023.
//

import Foundation
import NetworkingLayer
import SmilesUtilities
import SmilesOffers

// if you wish you can have multiple services like this in a project
enum OffersCategoryListRequestBuilder {
    
    // organise all the end points here for clarity
    case getOffersCategoryList(request: OffersCategoryRequestModel)
    
    // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    //specify the type of HTTP request
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getOffersCategoryList:
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
        case .getOffersCategoryList(let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(baseUrl: String, for endPoint: ManCityHomeEndPoints) -> String {
        return baseUrl + endPoint.serviceEndPoints
    }
}

