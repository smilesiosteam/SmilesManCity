//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import Foundation
import SmilesUtilities
import UIKit
import SmilesOffers
import SmilesBanners
import SmilesReusableComponents

struct ManCityHomeCellRegistration: CellRegisterable {
    
    func register(for tableView: UITableView) {
        
        tableView.registerCellFromNib(ManCityEnrollmentTableViewCell.self, bundle: .module)
        tableView.registerCellFromNib(FAQTableViewCell.self, bundle: FAQTableViewCell.module)
        tableView.register(UINib(nibName: String(describing: ManCityHeader.self), bundle: .module), forHeaderFooterViewReuseIdentifier: String(describing: ManCityHeader.self))
        tableView.registerCellFromNib(QuickAccessTableViewCell.self, bundle: .module)
        tableView.registerCellFromNib(ManCityVideoTableViewCell.self, bundle: .module)
        tableView.registerCellFromNib(RestaurantsRevampTableViewCell.self, bundle: RestaurantsRevampTableViewCell.module)
        tableView.registerCellFromNib(TopOffersTableViewCell.self, bundle: TopOffersTableViewCell.module)
        
    }
    
}
