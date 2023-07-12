//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 06/07/2023.
//

import UIKit
import SmilesSharedServices
import SmilesUtilities

final class ManCityRouter {
    
    static let shared = ManCityRouter()
    
    private init() {}
    
    func pushUserDetailsVC(navVC: UINavigationController, userData: RewardPointsResponseModel?, viewModel: ManCityHomeViewModel, proceedToPayment: @escaping ((String, String) -> Void)) {
        
        let vc = ManCityUserDetailsViewController(userData: userData, viewModel: viewModel, proceedToPayment: proceedToPayment)
        navVC.pushViewController(vc, animated: true)
        
    }
    
    func pushManCityVideoPlayerVC(navVC: UINavigationController, videoUrl: String, welcomeTitle: String) {
        if let vc = UIStoryboard(name: "ManCityVideoPlayer", bundle: .module).instantiateViewController(withIdentifier: "ManCityVideoPlayerViewController") as? ManCityVideoPlayerViewController {
            vc.videoUrl = videoUrl
            vc.welcomeTitle = welcomeTitle
            
            navVC.pushViewController(viewController: vc)
        }
    }
}
