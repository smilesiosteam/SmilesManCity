//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 05/07/2023.
//

import UIKit
import SmilesUtilities

extension ManCityHomeViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let enrollmentIndex = getSectionIndex(for: .enrollment), enrollmentIndex != section else {
            return nil
        }
        guard let quickAccessIndex = getSectionIndex(for: .quickAccess), quickAccessIndex != section else {
            return nil
        }
        if let sectionData = self.manCitySections?.sectionDetails?[safe: section] {
            let header = ManCityHeader()
            header.setupData(title: sectionData.title, subTitle: sectionData.subTitle, color: UIColor(hexString: sectionData.backgroundColor ?? ""))
            return header
        }
        return nil
        
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
