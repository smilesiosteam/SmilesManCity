//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 01/08/2023.
//
import Foundation

public enum InviteFriendsDataEndPoints: String, CaseIterable {
    case fetchInviteFriendsData
}

extension InviteFriendsDataEndPoints {
    var serviceEndPoints: String {
        switch self {
        case .fetchInviteFriendsData:
            return "mancity/invite-friend"
        }
    }
}

