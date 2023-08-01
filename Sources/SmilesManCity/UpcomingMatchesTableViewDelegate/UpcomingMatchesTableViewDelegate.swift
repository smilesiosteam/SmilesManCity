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
        
        if let offersIndex = getSectionIndex(for: .offerListing), offersIndex == indexPath.section {
            if let dataSource = ((self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<OfferDO
                                  >)) {
                if !dataSource.isDummy {
                    let offer = dataSource.models?[safe: indexPath.row] as? OfferDO
                    
                }
            }
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionData = self.upcomingMatchesSections?.sectionDetails?[safe: indexPath.section] {
            switch sectionData.sectionIdentifier {
            case UpcomingMatchesSectionIdentifier.teamRankings.rawValue:
                if let dataSource = (self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<TeamRankingResponseModel>) {
                    return abs(CGFloat(dataSource.models?.first?.data.count ?? 0) * 64.0 - 16)
                }
            default:
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if let isUserSubscribed {
//            if !isUserSubscribed {
//                if let faqIndex = getSectionIndex(for: .FAQS), faqIndex == section {
//                    return .leastNormalMagnitude
//                } else if let enrollmentIndex = getSectionIndex(for: .enrollment), enrollmentIndex == section {
//                    return 32.0
//                }
//            } else {
//                if let sectionData = self.upcomingMatchesSections?.sectionDetails?[safe: section] {
//                    switch sectionData.sectionIdentifier {
//                    default:
//                        return .leastNormalMagnitude
//                    }
//                }
//            }
//        }
        
        return .leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return nil
        }
        
        
        if let sectionData = self.upcomingMatchesSections?.sectionDetails?[safe: section] {
            if sectionData.sectionIdentifier != UpcomingMatchesSectionIdentifier.topPlaceholder.rawValue {
                let header = ManCityHeader()
                header.setupData(title: sectionData.title, subTitle: sectionData.subTitle, color: UIColor(hexString: sectionData.backgroundColor ?? ""))
                
                configureHeaderForShimmer(section: section, headerView: header)
                return header
            }
        }
        
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let isUserSubscribed {
            if !isUserSubscribed {
                return UITableView.automaticDimension
            } else {
                if let sectionData = self.upcomingMatchesSections?.sectionDetails?[safe: section] {
                    switch sectionData.sectionIdentifier {
                    case UpcomingMatchesSectionIdentifier.topPlaceholder.rawValue:
                        return .leastNormalMagnitude
                        
                    default:
                        return UITableView.automaticDimension
                    }
                }
            }
        }
        
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
        
        
        if let offerListingSectionIndex = getSectionIndex(for: .offerListing), offerListingSectionIndex == section {
            if let dataSource = (self.dataSource?.dataSources?[safe: offerListingSectionIndex] as? TableViewDataSource<OfferDO>) {
                showHide(isDummy: dataSource.isDummy)
            }
        }
        
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
