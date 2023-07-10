//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/07/2023.
//

import Foundation

struct QuickAccessResponseModel: Codable {
    let quickAccess: QuickAccessItem?
}

struct QuickAccessItem: Codable {
    let title: String?
    let subTitle: String?
    let links: [QuickAccessLink]?
}

struct QuickAccessLink: Codable {
    let linkIconUrl: String?
    let linkText: String?
    let redirectionUrl: String?
}
