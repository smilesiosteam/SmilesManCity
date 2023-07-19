//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/07/2023.
//

import Foundation

struct QuickAccessResponseModel: Codable {
    var quickAccess: QuickAccessItem?
}

struct QuickAccessItem: Codable {
    let title: String?
    let subTitle: String?
    var iconUrl: String?
    let links: [QuickAccessLink]?
}

struct QuickAccessLink: Codable {
    let linkIconUrl: String?
    let linkText: String?
    let redirectionUrl: String?
}
