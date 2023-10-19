////
////  File.swift
////
////
////  Created by Abdul Rehman Amjad on 16/10/2023.
////
//
//import UIKit
//import SmilesUtilities
//import SmilesSharedServices
//import SmilesOffers
//
//extension ManCityMerchStoreViewController: UITableViewDelegate {
//
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if let offersIndex = getSectionIndex(for: .offerListing), offersIndex == indexPath.section {
//            if let dataSource = ((self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<OfferDO
//                                  >)) {
//                if !dataSource.isDummy {
//                    let offer = dataSource.models?[safe: indexPath.row] as? OfferDO
//                    self.delegate?.proceedToOfferDetails(offer: offer)
//                }
//            }
//        }
//
//    }
//
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
//            return nil
//        }
//
//        if let sectionData = self.merchStoreSections?.sectionDetails?[safe: section] {
//            if sectionData.sectionIdentifier != ManCityHomeSectionIdentifier.quickAccess.rawValue && sectionData.sectionIdentifier != ManCityHomeSectionIdentifier.topPlaceholder.rawValue {
//                let header = ManCityHeader()
//                header.setupData(title: sectionData.title, subTitle: sectionData.subTitle, color: UIColor(hexString: sectionData.backgroundColor ?? ""))
//
//                configureHeaderForShimmer(section: section, headerView: header)
//                return header
//            }
//        }
//
//        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
//    }
//
//    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return CGFloat.leastNormalMagnitude
//    }
//
//    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func configureHeaderForShimmer(section: Int, headerView: UIView) {
//        func showHide(isDummy: Bool) {
//            if isDummy {
//                headerView.enableSkeleton()
//                headerView.showAnimatedGradientSkeleton()
//            } else {
//                headerView.hideSkeleton()
//            }
//        }
//
//        if let offerListingSectionIndex = getSectionIndex(for: .offerListing), offerListingSectionIndex == section {
//            if let dataSource = (self.dataSource?.dataSources?[safe: offerListingSectionIndex] as? TableViewDataSource<OfferDO>) {
//                showHide(isDummy: dataSource.isDummy)
//            }
//        }
//
//    }
//
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        var tableViewHeight = contentTableView.frame.height
//        if headerView.alpha == 0 {
//            tableViewHeight -= 153
//        }
//        guard scrollView.contentSize.height > tableViewHeight else { return }
//        var compact: Bool?
//        if scrollView.contentOffset.y > 90 {
//           compact = true
//        } else if scrollView.contentOffset.y < 0 {
//            compact = false
//        }
//        guard let compact, compact != (headerView.alpha == 0) else { return }
//        if compact {
//            self.setUpNavigationBar(isLightContent: false)
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
//                self.headerView.alpha = 0
//                self.tableViewTopSpaceToHeaderView.priority = .defaultLow
//                self.tableViewTopSpaceToSuperView.priority = .defaultHigh
//                self.view.layoutIfNeeded()
//            })
//        } else {
//            self.setUpNavigationBar()
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
//                self.headerView.alpha = 1
//                self.tableViewTopSpaceToHeaderView.priority = .defaultHigh
//                self.tableViewTopSpaceToSuperView.priority = .defaultLow
//                self.view.layoutIfNeeded()
//            })
//        }
//
//    }
//
//}
