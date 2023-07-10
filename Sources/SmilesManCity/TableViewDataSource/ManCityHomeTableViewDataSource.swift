//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 04/07/2023.
//

import Foundation
import SmilesUtilities
import SmilesSharedServices

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
            cell.bottomView.isHidden = faqDetail.isHidden ?? true
            cell.setupCell(faqDetail: faqDetail)
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
            cell.collectionsData = quickAccess.quickAccess?.links
            cell.didTapCell = { quickAccessLink in
                completion?(quickAccessLink)
            }
        }
    }
}

extension TableViewDataSource where Model == AboutVideo {
    static func make(forAboutVideo aboutVideo: AboutVideo,
                     reuseIdentifier: String = "ManCityVideoTableViewCell", data: String, isDummy: Bool = false, completion: ((String) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [aboutVideo],
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (aboutVideo, cell, data, indexPath) in
            guard let cell = cell as? ManCityVideoTableViewCell else { return }
            cell.setupCell(videoUrl: aboutVideo.videoUrl)
        }
    }
}
