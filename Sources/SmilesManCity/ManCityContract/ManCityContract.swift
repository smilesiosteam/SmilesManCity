//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import Foundation
import SmilesSharedServices
import SmilesUtilities
import SmilesOffers
import SmilesBanners
import SmilesReusableComponents

extension ManCityHomeViewModel {
    
    enum Input {
        case getSections(categoryID: Int)
        case getSubscriptionInfo
        case getRewardPoints
        case getFAQsDetails(faqId: Int)
        case getPlayersList
        case getQuickAccessList(categoryId: Int)
        case getOffersCategoryList(pageNo: Int, categoryId: String, searchByLocation: Bool, sortingType: String?, subCategoryId: String = "1", subCategoryTypeIdsList: [String]?)
        case emptyOffersList
        case updateOfferWishlistStatus(operation: Int, offerId: String)
        case getTopOffers(bannerType: String?, categoryId: Int?)
    }
    
    enum Output {
        case fetchSectionsDidSucceed(response: GetSectionsResponseModel)
        case fetchSectionsDidFail(error: Error)
        
        case fetchSubscriptionInfoDidSucceed(response: SubscriptionInfoResponse)
        case fetchSubscriptionInfoDidFail(error: Error)
        
        case fetchRewardPointsDidSucceed(response: RewardPointsResponseModel, shouldLogout: Bool?)
        case fetchRewardPointsDidFail(error: Error)
        
        case fetchFAQsDidSucceed(response: FAQsDetailsResponse)
        case fetchFAQsDidFail(error: Error)
        
        case fetchPlayersDidSucceed(response: ManCityPlayersResponse)
        case fetchPlayersDidFail(error: Error)
        
        case fetchQuickAccessListDidSucceed(response: QuickAccessResponseModel)
        case fetchQuickAccessListDidFail(error: Error)
        
        case fetchOffersCategoryListDidSucceed(response: OffersCategoryResponseModel)
        case fetchOffersCategoryListDidFail(error: Error)
        
        case emptyOffersListDidSucceed
        
        case updateWishlistStatusDidSucceed(response: WishListResponseModel)
        case updateWishlistStatusDidFail(error: Error)
        
        case fetchTopOffersDidSucceed(response: GetTopOffersResponseModel)
        case fetchTopOffersDidFail(error: Error)
    }
    
}
