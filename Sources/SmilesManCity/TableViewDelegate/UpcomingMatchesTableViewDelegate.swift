//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//

import UIKit
import SmilesUtilities
import SmilesSharedServices
import SmilesOffers

extension UpcomingMatchesViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionData = self.upcomingMatchesSections?.sectionDetails?[safe: indexPath.section] {
            switch sectionData.sectionIdentifier {
            case UpcomingMatchesSectionIdentifier.teamRankings.rawValue:
                if let dataSource = (self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<TeamRankingResponseModel>) {
                    return abs(CGFloat(dataSource.models?.first?.teamRankings?.count ?? 0) * 64.0 - 16)
                }
            default:
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return nil
        }
        
        
        if let sectionData = self.upcomingMatchesSections?.sectionDetails?[safe: section] {
            let header = ManCityHeader()
            header.setupData(title: sectionData.title, subTitle: sectionData.subTitle, color: UIColor(hexString: sectionData.backgroundColor ?? ""), showViewAllButton: true)
            
            configureHeaderForShimmer(section: section, headerView: header)
            return header
        }
        
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func configureHeaderForShimmer(section: Int, headerView: UIView) {
        func showHide(isDummy: Bool) {
            if isDummy {
                headerView.enableSkeleton()
                headerView.showAnimatedGradientSkeleton()
            } else {
                headerView.hideSkeleton()
            }
        }
        
        
//        if let offerListingSectionIndex = getSectionIndex(for: .offerListing), offerListingSectionIndex == section {
//            if let dataSource = (self.dataSource?.dataSources?[safe: offerListingSectionIndex] as? TableViewDataSource<OfferDO>) {
//                showHide(isDummy: dataSource.isDummy)
//            }
//        }
        
    }
    
}
