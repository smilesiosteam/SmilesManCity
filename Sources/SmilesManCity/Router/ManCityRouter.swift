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
    
    func pushUpcomingMatchesVC(navVC: UINavigationController, categoryId: Int) {
        
        let upcomingMatchesVC = UpcomingMatchesViewController(categoryId: categoryId)
        navVC.pushViewController(upcomingMatchesVC, animated: true)
        
    }
    
    public func pushManCityVideoPlayerVC(navVC: UINavigationController?, videoUrl: String, username: String?, isFirstTime: Bool = false, customPop: (()->Void)? = nil) -> ManCityVideoPlayerViewController{
        let vc = UIStoryboard(name: "ManCityVideoPlayer", bundle: .module).instantiateViewController(withIdentifier: "ManCityVideoPlayerViewController") as! ManCityVideoPlayerViewController
        vc.videoUrl = videoUrl
        vc.username = username
        vc.customPop = customPop
        vc.isFirstTime = isFirstTime
        navVC?.pushViewController(viewController: vc)
        return vc
    }
}
