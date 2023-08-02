//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 01/08/2023.
//

import Foundation

// MARK: - InviteFriendsResponse
struct InviteFriendsResponse: Codable {
    let extTransactionID: String
    let inviteFriend: InviteFriend

    enum CodingKeys: String, CodingKey {
        case extTransactionID = "extTransactionId"
        case inviteFriend
    }
}

// MARK: - InviteFriend
struct InviteFriend: Codable {
    let image: String
    let title, subtitle, referralCode, additionalInfo: String
    let invitationText: String
}
