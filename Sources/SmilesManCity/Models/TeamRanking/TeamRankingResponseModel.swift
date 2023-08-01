//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//

import Foundation
fileprivate var iconURL = "https://w7.pngwing.com/pngs/120/801/png-transparent-manchester-city-fc-hd-logo.png"
struct TeamRankingResponseModel: Codable {
    var data: [TeamRankingRowData] = []
    
    static func getTestData() -> TeamRankingResponseModel {
        TeamRankingResponseModel(data: [
            TeamRankingRowData(rankings: [
                TeamRanking(text: "Team"),TeamRanking(text: "P"),TeamRanking(text: "W"),TeamRanking(text: "D"),TeamRanking(text: "L"),TeamRanking(text: "GD"),TeamRanking(text: "Pts")
            ]),
            TeamRankingRowData(rankings: [
                TeamRanking(text: "Manchester City",iconUrl: iconURL),TeamRanking(text: "44"),TeamRanking(text: "8"),TeamRanking(text: "5"),TeamRanking(text: "88"),TeamRanking(text: "15"),TeamRanking(text: "7")
            ]),
            TeamRankingRowData(rankings: [
                TeamRanking(text: "A villa",iconUrl: iconURL),TeamRanking(text: "4"),TeamRanking(text: "33"),TeamRanking(text: "85"),TeamRanking(text: "88"),TeamRanking(text: "15"),TeamRanking(text: "0")
            ]),
            TeamRankingRowData(rankings: [
                TeamRanking(text: "Bournemouth",iconUrl: iconURL),TeamRanking(text: "8"),TeamRanking(text: "3"),TeamRanking(text: "85"),TeamRanking(text: "88"),TeamRanking(text: "15"),TeamRanking(text: "7")
            ]),
            TeamRankingRowData(rankings: [
                TeamRanking(text: "Brighton",iconUrl: iconURL),TeamRanking(text: "4"),TeamRanking(text: "3"),TeamRanking(text: "5"),TeamRanking(text: "88"),TeamRanking(text: "15"),TeamRanking(text: "7")
            ]),
            TeamRankingRowData(rankings: [
                TeamRanking(text: "Arsenal",iconUrl: iconURL),TeamRanking(text: "4"),TeamRanking(text: "31"),TeamRanking(text: "85"),TeamRanking(text: "88"),TeamRanking(text: "15"),TeamRanking(text: "7")
            ]),
        ])
        
    }
}

struct TeamRankingRowData: Codable {
    var rankings: [TeamRanking] = []
}

struct TeamRanking: Codable {
    var text: String?
    var iconUrl: String?
}
