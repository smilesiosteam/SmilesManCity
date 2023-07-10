//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 05/07/2023.
//

import UIKit
import SmilesUtilities
import SmilesSharedServices

extension ManCityHomeViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let faqIndex = getSectionIndex(for: .FAQS), faqIndex == indexPath.section {
            let faqDetail = ((self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<FaqsDetail>)?.models?[safe: indexPath.row] as? FaqsDetail)
            faqDetail?.isHidden = !(faqDetail?.isHidden ?? true)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let isUserSubscribed {
            if !isUserSubscribed {
                if let faqIndex = getSectionIndex(for: .FAQS), faqIndex == indexPath.section {
                    return UITableView.automaticDimension
                }
            } else {
                if let sectionData = self.manCitySections?.sectionDetails?[safe: indexPath.section] {
                    switch sectionData.sectionIdentifier {
                    case ManCitySectionIdentifier.quickAccess.rawValue:
                        return 64.0
                        
                    case ManCitySectionIdentifier.about.rawValue:
                        return 242.0
                    default:
                        return UITableView.automaticDimension
                    }
                }
            }
        }
        
        return UITableView.automaticDimension
    }
    
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
