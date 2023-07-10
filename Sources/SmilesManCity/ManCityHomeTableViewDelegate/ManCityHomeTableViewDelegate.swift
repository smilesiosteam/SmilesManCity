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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var tableViewHeight = contentTableView.frame.height
        if headerView.alpha == 0 {
            tableViewHeight -= 153
        }
        guard scrollView.contentSize.height > tableViewHeight else { return }
        var compact: Bool?
        if scrollView.contentOffset.y > 90 {
           compact = true
        } else if scrollView.contentOffset.y < 0 {
            compact = false
        }
        guard let compact, compact != (headerView.alpha == 0) else { return }
        if compact {
            self.setUpNavigationBar(isLightContent: false)
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                self.headerView.alpha = 0
                self.tableViewTopSpaceToHeaderView.priority = .defaultLow
                self.tableViewTopSpaceToSuperView.priority = .defaultHigh
                self.view.layoutIfNeeded()
            })
        } else {
            self.setUpNavigationBar()
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                self.headerView.alpha = 1
                self.tableViewTopSpaceToHeaderView.priority = .defaultHigh
                self.tableViewTopSpaceToSuperView.priority = .defaultLow
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
}
