//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 05/07/2023.
//

import UIKit
import SmilesUtilities
import SmilesSharedServices
import SmilesOffers

extension ManCityHomeViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let faqIndex = getSectionIndex(for: .FAQS), faqIndex == indexPath.section {
            let faqDetail = ((self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<FaqsDetail>)?.models?[safe: indexPath.row] as? FaqsDetail)
            faqDetail?.isHidden = !(faqDetail?.isHidden ?? true)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else if let aboutVideoIndex = getSectionIndex(for: .about), aboutVideoIndex == indexPath.section {
            if let dataSource = ((self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<AboutVideo
                                  >)) {
                if !dataSource.isDummy {
                    let aboutVideo = dataSource.models?[safe: indexPath.row] as? AboutVideo
                    if let navigationController {
                        let _ = ManCityRouter.shared.pushManCityVideoPlayerVC(navVC: navigationController, videoUrl: aboutVideo?.videoUrl ?? "", username: self.username)
                    }
                }
            }
        } else if let offersIndex = getSectionIndex(for: .offerListing), offersIndex == indexPath.section {
            if let dataSource = ((self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<OfferDO
                                  >)) {
                if !dataSource.isDummy {
                    let offer = dataSource.models?[safe: indexPath.row] as? OfferDO
                    self.proceedToOfferDetails?(offer)
                }
            }
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
                        return 236.0
                        
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
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let isUserSubscribed {
            if !isUserSubscribed {
                if let faqIndex = getSectionIndex(for: .FAQS), faqIndex == section {
                    return .leastNormalMagnitude
                } else if let enrollmentIndex = getSectionIndex(for: .enrollment), enrollmentIndex == section {
                    return 32.0
                }
            } else {
                if let sectionData = self.manCitySections?.sectionDetails?[safe: section] {
                    switch sectionData.sectionIdentifier {
                    case ManCitySectionIdentifier.quickAccess.rawValue:
                        return 24.0
                        
                    default:
                        return .leastNormalMagnitude
                    }
                }
            }
        }
        
        return .leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return nil
        }
        
        if let isUserSubscribed {
            if !isUserSubscribed {
                if let faqIndex = getSectionIndex(for: .FAQS), faqIndex == section {
                    let header = ManCityHeader()
                    header.setupData(title: "FAQs", subTitle: nil, color: .clear)
                    return header
                }
            } else {
                if let sectionData = self.manCitySections?.sectionDetails?[safe: section] {
                    if sectionData.sectionIdentifier != ManCitySectionIdentifier.quickAccess.rawValue && sectionData.sectionIdentifier != ManCitySectionIdentifier.topPlaceholder.rawValue {
                        let header = ManCityHeader()
                        header.setupData(title: sectionData.title, subTitle: sectionData.subTitle, color: UIColor(hexString: sectionData.backgroundColor ?? ""))
                        
                        configureHeaderForShimmer(section: section, headerView: header)
                        return header
                    }
                }
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
                if let sectionData = self.manCitySections?.sectionDetails?[safe: section] {
                    switch sectionData.sectionIdentifier {
                    case ManCitySectionIdentifier.topPlaceholder.rawValue, ManCitySectionIdentifier.quickAccess.rawValue:
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
        
        if let quickAccessSectionIndex = getSectionIndex(for: .quickAccess), quickAccessSectionIndex == section {
            if let dataSource = self.dataSource?.dataSources?[safe: quickAccessSectionIndex] as? TableViewDataSource<QuickAccessResponseModel> {
                showHide(isDummy: dataSource.isDummy)
            }
        }
        
        if let offerListingSectionIndex = getSectionIndex(for: .offerListing), offerListingSectionIndex == section {
            if let dataSource = (self.dataSource?.dataSources?[safe: offerListingSectionIndex] as? TableViewDataSource<OfferDO>) {
                showHide(isDummy: dataSource.isDummy)
            }
        }
        
        if let aboutSectionIndex = getSectionIndex(for: .about), aboutSectionIndex == section {
            if let dataSource = (self.dataSource?.dataSources?[safe: aboutSectionIndex] as? TableViewDataSource<AboutVideo>) {
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
