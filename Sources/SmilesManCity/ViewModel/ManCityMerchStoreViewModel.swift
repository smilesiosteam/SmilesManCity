//
//  File.swift
//
//
//  Created by Abdul Rehman Amjad on 13/10/2023.
//

import Foundation
import Combine
import SmilesSharedServices
import SmilesOffers
import SmilesUtilities

class ManCityMerchStoreViewModel: NSObject {

    // MARK: - PROPERTIES -
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - VIEWMODELS -
    private let sectionsViewModel = SectionsViewModel()
    private let offersCategoryListViewModel = OffersCategoryListViewModel()
    private let wishListViewModel = WishListViewModel()

    private var sectionsUseCaseInput: PassthroughSubject<SectionsViewModel.Input, Never> = .init()
    private var offersCategoryListUseCaseInput: PassthroughSubject<OffersCategoryListViewModel.Input, Never> = .init()
    private var wishListUseCaseInput: PassthroughSubject<WishListViewModel.Input, Never> = .init()

}

// MARK: - VIEWMODELS BINDINGS -
extension ManCityMerchStoreViewModel {

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getSections(categoryID: let categoryID):
                self?.bind(to: self?.sectionsViewModel ?? SectionsViewModel())
                self?.sectionsUseCaseInput.send(.getSections(categoryID: categoryID, baseUrl: AppCommonMethods.serviceBaseUrl, isGuestUser: AppCommonMethods.isGuestUser, type: "LANDING"))

            case .getOffersCategoryList(let pageNo, let categoryId, let searchByLocation, let sortingType, let subCategoryId, let subCategoryTypeIdsList):
                self?.bind(to: self?.offersCategoryListViewModel ?? OffersCategoryListViewModel())
                self?.offersCategoryListUseCaseInput.send(.getOffersCategoryList(pageNo: pageNo, categoryId: categoryId, searchByLocation: searchByLocation, sortingType: sortingType, subCategoryId: subCategoryId, subCategoryTypeIdsList: subCategoryTypeIdsList))

            case .updateOfferWishlistStatus(let operation, let offerId):
                self?.bind(to: self?.wishListViewModel ?? WishListViewModel())
                self?.wishListUseCaseInput.send(.updateOfferWishlistStatus(operation: operation, offerId: offerId, baseUrl: AppCommonMethods.serviceBaseUrl))
            default: break
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

}
