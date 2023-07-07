//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 06/07/2023.
//

import UIKit
import SmilesSharedServices

final class ManCityRouter {
    
    static let shared = ManCityRouter()
    
    private init() {}
    
    func pushUserDetailsVC(navVC: UINavigationController, userData: RewardPointsResponseModel?, viewModel: ManCityHomeViewModel) {
        
        let vc = ManCityUserDetailsViewController(userData: userData, viewModel: viewModel)
        navVC.pushViewController(vc, animated: true)
        
    }
    
}
