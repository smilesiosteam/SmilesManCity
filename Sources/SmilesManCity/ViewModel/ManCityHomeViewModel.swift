//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import Foundation
import Combine
import SmilesSharedServices
import SmilesUtilities
import NetworkingLayer
import SmilesLocationHandler
import SmilesOffers
import SmilesBanners
import SmilesReusableComponents

class ManCityHomeViewModel: NSObject {
    
    // MARK: - PROPERTIES -
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - VIEWMODELS -
    private let sectionsViewModel = SectionsViewModel()
    private let rewardPointsViewModel = RewardPointsViewModel()
    private let faqsViewModel = FAQsViewModel()
    private let quickAccessViewModel = QuickAccessViewModel()
    private let offersCategoryListViewModel = OffersCategoryListViewModel()
    private let wishListViewModel = WishListViewModel()
    private let topOffersViewModel = TopOffersViewModel()
    
    private var sectionsUseCaseInput: PassthroughSubject<SectionsViewModel.Input, Never> = .init()
    private var rewardPointsUseCaseInput: PassthroughSubject<RewardPointsViewModel.Input, Never> = .init()
    private var faqsUseCaseInput: PassthroughSubject<FAQsViewModel.Input, Never> = .init()
    private var quickAccessUseCaseInput: PassthroughSubject<QuickAccessViewModel.Input, Never> = .init()
    private var offersCategoryListUseCaseInput: PassthroughSubject<OffersCategoryListViewModel.Input, Never> = .init()
    private var wishListUseCaseInput: PassthroughSubject<WishListViewModel.Input, Never> = .init()
    private var topOffersUseCaseInput: PassthroughSubject<TopOffersViewModel.Input, Never> = .init()
    
    
    // MARK: - METHODS -
    private func logoutUser() {
        UserDefaults.standard.set(false, forKey: .notFirstTime)
        UserDefaults.standard.set(true, forKey: .isLoggedOut)
        UserDefaults.standard.removeObject(forKey: .loyaltyID)
        LocationStateSaver.removeLocation()
        LocationStateSaver.removeRecentLocations()
    }
    
}

// MARK: - VIEWMODELS BINDINGS -
extension ManCityHomeViewModel {
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getSections(categoryID: let categoryID):
                self?.bind(to: self?.sectionsViewModel ?? SectionsViewModel())
                self?.sectionsUseCaseInput.send(.getSections(categoryID: categoryID, baseUrl: AppCommonMethods.serviceBaseUrl, isGuestUser: AppCommonMethods.isGuestUser, type: "LANDING"))
                
            case .getSubscriptionInfo:
                self?.getSubscriptionInfo()
                
            case .getRewardPoints:
                self?.bind(to: self?.rewardPointsViewModel ?? RewardPointsViewModel())
                self?.rewardPointsUseCaseInput.send(.getRewardPoints(baseUrl: AppCommonMethods.serviceBaseUrl))
                
            case .getFAQsDetails(faqId: let faqId):
                self?.bind(to: self?.faqsViewModel ?? FAQsViewModel())
                self?.faqsUseCaseInput.send(.getFAQsDetails(faqId: faqId, baseUrl: AppCommonMethods.serviceBaseUrl))
                
            case .getPlayersList:
                self?.getPlayersList()
                
            case .getQuickAccessList(let categoryId):
                self?.bind(to: self?.quickAccessViewModel ?? QuickAccessViewModel())
                self?.quickAccessUseCaseInput.send(.getQuickAccessList(categoryId: categoryId))
                
            case .getOffersCategoryList(let pageNo, let categoryId, let searchByLocation, let sortingType, let subCategoryId, let subCategoryTypeIdsList):
                self?.bind(to: self?.offersCategoryListViewModel ?? OffersCategoryListViewModel())
                var latitude = 0.0
                var longitude = 0.0
                
                if let userInfo = LocationStateSaver.getLocationInfo(){
                    latitude = Double(userInfo.latitude ?? "0.0") ?? 0.0
                    longitude = Double(userInfo.longitude ?? "0.0") ?? 0.0
                }
                
                self?.offersCategoryListUseCaseInput.send(.getOffersCategoryList(pageNo: pageNo, categoryId: categoryId, searchByLocation: searchByLocation, sortingType: sortingType, subCategoryId: subCategoryId, subCategoryTypeIdsList: subCategoryTypeIdsList, latitude: latitude, longitude: longitude))
                
            case .emptyOffersList:
                self?.output.send(.emptyOffersListDidSucceed)
                
            case .updateOfferWishlistStatus(let operation, let offerId):
                self?.bind(to: self?.wishListViewModel ?? WishListViewModel())
                self?.wishListUseCaseInput.send(.updateOfferWishlistStatus(operation: operation, offerId: offerId, baseUrl: AppCommonMethods.serviceBaseUrl))
            case .getTopOffers(bannerType: let bannerType, categoryId: let categoryId):
                self?.bind(to: self?.topOffersViewModel ?? TopOffersViewModel())
                self?.topOffersUseCaseInput.send(.getTopOffers(menuItemType: nil, bannerType: bannerType, categoryId: categoryId, bannerSubType: nil, isGuestUser: false, baseUrl: AppCommonMethods.serviceBaseUrl))
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func bind(to sectionsViewModel: SectionsViewModel) {
        sectionsUseCaseInput = PassthroughSubject<SectionsViewModel.Input, Never>()
        let output = sectionsViewModel.transform(input: sectionsUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    debugPrint(sectionsResponse)
                    self?.output.send(.fetchSectionsDidSucceed(response: sectionsResponse))
                case .fetchSectionsDidFail(let error):
                    self?.output.send(.fetchSectionsDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    func bind(to rewardPointsViewModel: RewardPointsViewModel) {
        rewardPointsUseCaseInput = PassthroughSubject<RewardPointsViewModel.Input, Never>()
        let output = rewardPointsViewModel.transform(input: rewardPointsUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchRewardPointsDidSucceed(let response, _):
                    if let responseCode = response.responseCode {
                        if responseCode == "101" || responseCode == "0000252" {
                            self?.logoutUser()
                            self?.output.send(.fetchRewardPointsDidSucceed(response: response, shouldLogout: true))
                        }
                    } else {
                        if response.totalPoints != nil {
                            self?.output.send(.fetchRewardPointsDidSucceed(response: response, shouldLogout: false))
                        }
                    }
                case .fetchRewardPointsDidFail(let error):
                    self?.output.send(.fetchRewardPointsDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    func bind(to faqsViewModel: FAQsViewModel) {
        faqsUseCaseInput = PassthroughSubject<FAQsViewModel.Input, Never>()
        let output = faqsViewModel.transform(input: faqsUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchFAQsDidSucceed(let response):
                    self?.output.send(.fetchFAQsDidSucceed(response: response))
                case .fetchFAQsDidFail(let error):
                    self?.output.send(.fetchFAQsDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    func bind(to quickAccessViewModel: QuickAccessViewModel) {
        quickAccessUseCaseInput = PassthroughSubject<QuickAccessViewModel.Input, Never>()
        let output = quickAccessViewModel.transform(input: quickAccessUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchQuickAccessListDidSucceed(let response):
                    self?.output.send(.fetchQuickAccessListDidSucceed(response: response))
                    
                case .fetchQuickAccessListDidFail(let error):
                    self?.output.send(.fetchQuickAccessListDidFail(error: error))
                }
        }.store(in: &cancellables)
    }
    
    // OffersCategoryList ViewModel Binding
    func bind(to offersCategoryListViewModel: OffersCategoryListViewModel) {
        offersCategoryListUseCaseInput = PassthroughSubject<OffersCategoryListViewModel.Input, Never>()
        let output = offersCategoryListViewModel.transform(input: offersCategoryListUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchOffersCategoryListDidSucceed(let offersCategoryListResponse):
                    self?.output.send(.fetchOffersCategoryListDidSucceed(response: offersCategoryListResponse))
                case .fetchOffersCategoryListDidFail(let error):
                    self?.output.send(.fetchOffersCategoryListDidFail(error: error))
            }
        }.store(in: &cancellables)
    }
    
    // WishList ViewModel Binding
    func bind(to wishListViewModel: WishListViewModel) {
        wishListUseCaseInput = PassthroughSubject<WishListViewModel.Input, Never>()
        let output = wishListViewModel.transform(input: wishListUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .updateWishlistStatusDidSucceed(response: let response):
                    self?.output.send(.updateWishlistStatusDidSucceed(response: response))
                case .updateWishlistDidFail(error: let error):
                    debugPrint(error)
                    break
                }
            }.store(in: &cancellables)
    }
    
    // TopOffers ViewModel Binding
    func bind(to topOffersViewModel: TopOffersViewModel) {
        topOffersUseCaseInput = PassthroughSubject<TopOffersViewModel.Input, Never>()
        let output = topOffersViewModel.transform(input: topOffersUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchTopOffersDidSucceed(let topOffersResponse):
                    debugPrint(topOffersResponse)
                    self?.output.send(.fetchTopOffersDidSucceed(response: topOffersResponse))
                case .fetchTopOffersDidFail(let error):
                    self?.output.send(.fetchTopOffersDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
}

// MARK: - API CALLS -
extension ManCityHomeViewModel {
    
    private func getSubscriptionInfo() {
        
        let request = SubscriptionInfoRequest()
        let service = ManCityHomeRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .getSubscriptionInfo
        )
        service.getSubscriptionInfoService(request: request)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchSubscriptionInfoDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                self?.output.send(.fetchSubscriptionInfoDidSucceed(response: response))
            }
        .store(in: &cancellables)
        
    }
    
    private func getPlayersList() {
        
        let request = ManCityPlayersRequest()
        let service = ManCityUserDetailsRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl
        )
        service.getPlayersService(request: request)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchPlayersDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                self?.output.send(.fetchPlayersDidSucceed(response: response))
            }
        .store(in: &cancellables)
        
    }
    
}
