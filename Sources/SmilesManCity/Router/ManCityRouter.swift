//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 06/07/2023.
//

import UIKit
import SmilesSharedServices
import SmilesUtilities

@objcMembers
public final class ManCityRouter: NSObject {
    
    public static let shared = ManCityRouter()
    
    private override init() {}
    
    func pushUserDetailsVC(navVC: UINavigationController, userData: RewardPointsResponseModel?, viewModel: ManCityHomeViewModel, proceedToPayment: @escaping ((String, String, Bool) -> Void)) {
        
        let vc = ManCityUserDetailsViewController(userData: userData, viewModel: viewModel, proceedToPayment: proceedToPayment)
        navVC.pushViewController(vc, animated: true)
        
    }
    
    public func pushUpcomingMatchesVC(navVC: UINavigationController, categoryId: Int) {
        
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
    
    public func pushManCityInviteFirendsVC(navVC: UINavigationController?, onInviteSend:@escaping ()->Void) {
        let vc = ManCityInviteFriendsViewController(onInviteSent: onInviteSend)
        navVC?.pushViewController(vc, animated: true)
    }
    
    func pushManCityTeamRankingsVC(navVC: UINavigationController, teamRankings: [TeamRanking]) {
        
        let teamRankingsVC = ManCityTeamRankingsViewController(teamRankings: teamRankings)
        navVC.pushViewController(teamRankingsVC, animated: true)
        
    }
    
    func openExtrenalURL(url: URL) {
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        
    }
    
}
