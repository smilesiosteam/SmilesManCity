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
        
        if let isUserSubscribed {
            if !isUserSubscribed {
                if let faqIndex = getSectionIndex(for: .FAQS), faqIndex == section {
                    let header = ManCityHeader()
                    header.setupData(title: "FAQs", subTitle: nil, color: .clear)
                    return header
                }
            } else {
                if let sectionData = self.manCitySections?.sectionDetails?[safe: section] {
                    let header = ManCityHeader()
                    header.setupData(title: sectionData.title, subTitle: sectionData.subTitle, color: UIColor(hexString: sectionData.backgroundColor ?? ""))
                    return header
                }
            }
        }
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
