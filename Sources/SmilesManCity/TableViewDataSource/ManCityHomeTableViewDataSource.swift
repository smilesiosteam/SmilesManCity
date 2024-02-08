//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 04/07/2023.
//

import Foundation
import SmilesUtilities
import SmilesSharedServices
import UIKit
import SmilesOffers
import SmilesBanners
import SmilesReusableComponents

extension TableViewDataSource where Model == SubscriptionInfoResponse {
    static func make(forEnrollment  subscriptionInfo: SubscriptionInfoResponse,
                     reuseIdentifier: String = "ManCityEnrollmentTableViewCell", data : String, isDummy:Bool = false, completion:(() -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [subscriptionInfo],
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy:isDummy
        ) { (subscription, cell, data, indexPath) in
            guard let cell = cell as? ManCityEnrollmentTableViewCell else {return}
            cell.setupData(subscriptionData: subscription)
            cell.enrollPressed = completion
        }
    }
}

extension TableViewDataSource where Model == FaqsDetail {
    static func make(forFAQs  faqsDetails: [FaqsDetail],
                     reuseIdentifier: String = "FAQTableViewCell", data : String, isDummy:Bool = false, completion:(() -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: faqsDetails,
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy:isDummy
        ) { (faqDetail, cell, data, indexPath) in
            guard let cell = cell as? FAQTableViewCell else {return}
            cell.bottomViewIsHidden = faqDetail.isHidden ?? true
            cell.setupCell(model: faqDetail)
        }
    }
}

extension TableViewDataSource where Model == QuickAccessResponseModel {
    static func make(forQuickAccess quickAccess: QuickAccessResponseModel,
                     reuseIdentifier: String = "QuickAccessTableViewCell", data: String, isDummy: Bool = false, completion: ((QuickAccessLink) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [quickAccess],
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (quickAccess, cell, data, indexPath) in
            guard let cell = cell as? QuickAccessTableViewCell else { return }
            cell.configureCell(with: quickAccess)
            cell.collectionsData = quickAccess.quickAccess?.links
            cell.didTapCell = { quickAccessLink in
                completion?(quickAccessLink)
            }
        }
    }
}

extension TableViewDataSource where Model == AboutVideo {
    static func make(forAboutVideo aboutVideo: AboutVideo,
                     reuseIdentifier: String = "ManCityVideoTableViewCell", data: String, isDummy: Bool = false) -> TableViewDataSource {
        return TableViewDataSource(
            models: [aboutVideo].filter { !($0.videoUrl?.isEmpty ?? false) },
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (aboutVideo, cell, data, indexPath) in
            guard let cell = cell as? ManCityVideoTableViewCell else { return }
            cell.setupCell(videoUrl: aboutVideo.videoUrl)
        }
    }
}

extension TableViewDataSource where Model == OfferDO {
    static func make(forNearbyOffers nearbyOffersObjects: [OfferDO], offerCellType: RestaurantsRevampTableViewCell.OfferCellType = .manCity,
                     reuseIdentifier: String = "RestaurantsRevampTableViewCell", data: String, isDummy: Bool = false, completion: ((Bool, String, IndexPath?) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: nearbyOffersObjects,
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (offer, cell, data, indexPath) in
            guard let cell = cell as? RestaurantsRevampTableViewCell else { return }
            cell.configureCell(with: offer)
            cell.offerCellType = offerCellType
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.favoriteCallback = { isFavorite, offerId in
                completion?(isFavorite, offerId, indexPath)
            }
        }
    }
}

extension TableViewDataSource where Model == GetTopOffersResponseModel {
    static func make(forTopOffers collectionsObject: GetTopOffersResponseModel,
                     reuseIdentifier: String = "TopOffersTableViewCell", data : String, isDummy:Bool = false, completion:((GetTopOffersResponseModel.TopOfferAdsDO) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.ads?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (topOffers, cell, data, indexPath) in
            guard let cell = cell as? TopOffersTableViewCell else {return}
            cell.showPageControl = false
            cell.sliderTimeInterval = topOffers.sliderTimeout
            cell.collectionsData = topOffers.ads
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.callBack = { data in
                completion?(data)
            }
        }
    }
}
