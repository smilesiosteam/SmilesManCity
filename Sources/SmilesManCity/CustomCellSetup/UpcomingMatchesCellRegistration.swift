//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//

import Foundation
import SmilesUtilities
import UIKit

struct UpcomingMatchesCellRegistration: CellRegisterable {
    
    func register(for tableView: UITableView) {
        
        tableView.registerCellFromNib(ManCityEnrollmentTableViewCell.self, bundle: .module)
        
        tableView.register(UINib(nibName: String(describing: ManCityHeader.self), bundle: .module), forHeaderFooterViewReuseIdentifier: String(describing: ManCityHeader.self))
        tableView.registerCellFromNib(TeamRankingTableViewCell.self, bundle: TeamRankingTableViewCell.module)
        
    }
    
}
