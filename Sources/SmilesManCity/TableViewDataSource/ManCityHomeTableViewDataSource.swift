//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 04/07/2023.
//

import Foundation
import SmilesUtilities

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
        }
    }
}
