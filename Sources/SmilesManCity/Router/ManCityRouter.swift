//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 06/07/2023.
//

import UIKit
import SmilesSharedServices
import SmilesUtilities

public final class ManCityRouter {
    
    public static let shared = ManCityRouter()
    
    private init() {}
    
    func pushUserDetailsVC(navVC: UINavigationController, userData: RewardPointsResponseModel?, viewModel: ManCityHomeViewModel, proceedToPayment: @escaping ((String, String, Bool) -> Void)) {
        
        let vc = ManCityUserDetailsViewController(userData: userData, viewModel: viewModel, proceedToPayment: proceedToPayment)
        navVC.pushViewController(vc, animated: true)
        
    }
    
    public func pushManCityVideoPlayerVC(navVC: UINavigationController?, videoUrl: String, welcomeTitle: String?, customPop: (()->Void)? = nil) -> ManCityVideoPlayerViewController{
        let vc = UIStoryboard(name: "ManCityVideoPlayer", bundle: .module).instantiateViewController(withIdentifier: "ManCityVideoPlayerViewController") as! ManCityVideoPlayerViewController
        vc.videoUrl = videoUrl
        vc.welcomeTitle = welcomeTitle
        vc.customPop = customPop
        navVC?.pushViewController(viewController: vc)
        return vc
    }
}
