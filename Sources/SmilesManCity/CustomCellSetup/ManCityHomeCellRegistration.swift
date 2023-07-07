//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import Foundation
import SmilesUtilities
import UIKit

struct ManCityHomeCellRegistration: CellRegisterable {
    
    func register(for tableView: UITableView) {
        
        tableView.registerCellFromNib(ManCityEnrollmentTableViewCell.self, bundle: .module)
        tableView.registerCellFromNib(FAQTableViewCell.self, bundle: .module)
        tableView.register(UINib(nibName: String(describing: ManCityHeader.self), bundle: .module), forHeaderFooterViewReuseIdentifier: String(describing: ManCityHeader.self))
        
    }
    
}