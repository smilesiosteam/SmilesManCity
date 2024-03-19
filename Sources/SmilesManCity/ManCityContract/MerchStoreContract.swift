//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 16/10/2023.
//

import Foundation
import SmilesSharedServices
import SmilesOffers

extension ManCityMerchStoreViewModel {
    
    enum Input {
        case getSections(categoryID: Int)
        case getOffersCategoryList(pageNo: Int, categoryId: String, searchByLocation: Bool, sortingType: String?, subCategoryId: String?, subCategoryTypeIdsList: [String]?)
        case updateOfferWishlistStatus(operation: Int, offerId: String)
        case emptyOffersList
    }
    
    enum Output {
        case fetchSectionsDidSucceed(response: GetSectionsResponseModel)
        case fetchSectionsDidFail(error: Error)
        
        case fetchOffersCategoryListDidSucceed(response: OffersCategoryResponseModel)
        case fetchOffersCategoryListDidFail(error: Error)
        
        case updateWishlistStatusDidSucceed(response: WishListResponseModel)
        case updateWishlistStatusDidFail(error: Error)
        
        case emptyOffersListDidSucceed
    }
    
}
