//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//

import Foundation
import SmilesUtilities
import SmilesSharedServices
import UIKit

 extension TableViewDataSource where Model == TeamRankingResponseModel {
     static func make(rankingsResponse: [TeamRankingResponseModel],
                      reuseIdentifier: String = "TeamRankingTableViewCell", data: String, isDummy: Bool = false, completion: ((TeamRanking, IndexPath?) -> ())?) -> TableViewDataSource {
         return TableViewDataSource(
             models: rankingsResponse,
             reuseIdentifier: reuseIdentifier,
             data: data,
             isDummy: isDummy
         ) { (response, cell, data, indexPath) in
             guard let cell = cell as? TeamRankingTableViewCell else { return }
             cell.teamRankingResponse = response
//             cell.setBackGroundColor(color: UIColor(hexString: data))
             cell.didTapCell = {teamRanking in
                 completion?(teamRanking, indexPath)
             }
         }
     }
 }
