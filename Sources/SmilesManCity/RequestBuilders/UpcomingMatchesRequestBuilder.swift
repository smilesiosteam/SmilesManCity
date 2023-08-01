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
    case getOffersCategoryList(request: OffersCategoryRequestModel)
    var requestTimeOut: Int {
        return 20
    }
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getOffersCategoryList:
            return .POST
        }
    }
    func createRequest(baseUrl: String, endPoint: ManCityHomeEndPoints) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(baseUrl: baseUrl, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    var requestBody: Encodable? {
        switch self {
        case .getOffersCategoryList(let request):
            return request
        }
    }
    
    func getURL(baseUrl: String, for endPoint: ManCityHomeEndPoints) -> String {
        return baseUrl + endPoint.serviceEndPoints
    }
}

