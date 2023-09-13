//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//

import Foundation

public enum UpcomingMatchesEndPoints: String, CaseIterable {
    case offersCategoryList
}

extension UpcomingMatchesEndPoints {
    var serviceEndPoints: String {
        switch self {
        case .offersCategoryList:
            return "home/get-offers-category-list"
        }
    }
}

