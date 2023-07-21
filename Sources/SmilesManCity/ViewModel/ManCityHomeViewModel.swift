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
    
    private var sectionsUseCaseInput: PassthroughSubject<SectionsViewModel.Input, Never> = .init()
    private var rewardPointsUseCaseInput: PassthroughSubject<RewardPointsViewModel.Input, Never> = .init()
    private var faqsUseCaseInput: PassthroughSubject<FAQsViewModel.Input, Never> = .init()
    private var quickAccessUseCaseInput: PassthroughSubject<QuickAccessViewModel.Input, Never> = .init()
    private var offersCategoryListUseCaseInput: PassthroughSubject<OffersCategoryListViewModel.Input, Never> = .init()
    private var wishListUseCaseInput: PassthroughSubject<WishListViewModel.Input, Never> = .init()
    
    private var filtersSavedList: [RestaurantRequestWithNameFilter]?
    private var filtersList: [RestaurantRequestFilter]?
    private var selectedSortingTableViewCellModel: FilterDO?
    private var selectedSort: String?
    
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
                self?.sectionsUseCaseInput.send(.getSections(categoryID: categoryID, baseUrl: AppCommonMethods.serviceBaseUrl, isGuestUser: AppCommonMethods.isGuestUser))
                
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
                self?.offersCategoryListUseCaseInput.send(.getOffersCategoryList(pageNo: pageNo, categoryId: categoryId, searchByLocation: searchByLocation, sortingType: sortingType, subCategoryId: subCategoryId, subCategoryTypeIdsList: subCategoryTypeIdsList))
                
            case .getFiltersData(let filtersSavedList, let isFilterAllowed, let isSortAllowed):
                self?.createFiltersData(filtersSavedList: filtersSavedList, isFilterAllowed: isFilterAllowed, isSortAllowed: isSortAllowed)
                
            case .removeAndSaveFilters(let filter):
                self?.removeAndSaveFilters(filter: filter)
                
            case .getSortingList:
                self?.output.send(.fetchSortingListDidSucceed)
                
            case .generateActionContentForSortingItems(let sortingModel):
                self?.generateActionContentForSortingItems(sortingModel: sortingModel)
                
            case .emptyOffersList:
                self?.output.send(.emptyOffersListDidSucceed)
                
            case .setFiltersSavedList(let filtersSavedList, let filtersList):
                self?.filtersSavedList = filtersSavedList
                self?.filtersList = filtersList
                
            case .setSelectedSort(let sortTitle):
                self?.selectedSort = sortTitle
                
            case .updateOfferWishlistStatus(let operation, let offerId):
                self?.bind(to: self?.wishListViewModel ?? WishListViewModel())
                self?.wishListUseCaseInput.send(.updateOfferWishlistStatus(operation: operation, offerId: offerId, baseUrl: AppCommonMethods.serviceBaseUrl))
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

// MARK: -- Filter and sorting

extension ManCityHomeViewModel {
    // Create Filters Data
    func createFiltersData(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?) {
        var filters = [FiltersCollectionViewCellRevampModel]()
        
        // Filter List
        var firstFilter = FiltersCollectionViewCellRevampModel(name: "Filters".localizedString, leftImage: "", rightImage: "filter-revamp", filterCount: filtersSavedList?.count ?? 0)
        
        let firstFilterRowWidth = AppCommonMethods.getAutoWidthWith(firstFilter.name, font: .circularXXTTBookFont(size: 14), additionalWidth: 60)
        firstFilter.rowWidth = firstFilterRowWidth
        
        let sortByTitle = !self.selectedSort.asStringOrEmpty().isEmpty ? "\("SortbyTitle".localizedString): \(self.selectedSort.asStringOrEmpty())" : "\("SortbyTitle".localizedString)"
        var secondFilter = FiltersCollectionViewCellRevampModel(name: sortByTitle, leftImage: "", rightImage: "sortby-chevron-down", rightImageWidth: 0, rightImageHeight: 4, tag: RestaurantFiltersType.deliveryTime.rawValue)
        
        let secondFilterRowWidth = AppCommonMethods.getAutoWidthWith(secondFilter.name, font: .circularXXTTBookFont(size: 14), additionalWidth: 40)
        secondFilter.rowWidth = secondFilterRowWidth
        
        if isFilterAllowed != 0 {
            filters.append(firstFilter)
        }
        
        if isSortAllowed != 0 {
            filters.append(secondFilter)
        }
        
        if let appliedFilters = filtersSavedList, appliedFilters.count > 0 {
            for filter in appliedFilters {
                
                let width = AppCommonMethods.getAutoWidthWith(filter.filterName.asStringOrEmpty(), font: .circularXXTTMediumFont(size: 22), additionalWidth: 30)
                
                let model = FiltersCollectionViewCellRevampModel(name: filter.filterName.asStringOrEmpty(), leftImage: "", rightImage: "filters-cross", isFilterSelected: true, filterValue: filter.filterValue.asStringOrEmpty(), tag: 0, rowWidth: width)

                filters.append(model)

            }
        }
        
        self.output.send(.fetchFiltersDataSuccess(filters: filters, selectedSortingTableViewCellModel: self.selectedSortingTableViewCellModel)) // Send filters back to VC
    }
    
    // Get saved filters
//    func getSavedFilters() -> [RestaurantRequestFilter] {
//        if let savedFilters = UserDefaults.standard.object([RestaurantRequestWithNameFilter].self, with: FilterDictTags.FiltersDict.rawValue) {
//            if savedFilters.count > 0 {
//                let uniqueUnordered = Array(Set(savedFilters))
//
//                filtersSavedList = uniqueUnordered
//
//                filtersList = [RestaurantRequestFilter]()
//
//                if let savedFilters = filtersSavedList {
//                    for filter in savedFilters {
//                        let restaurantRequestFilter = RestaurantRequestFilter()
//                        restaurantRequestFilter.filterKey = filter.filterKey
//                        restaurantRequestFilter.filterValue = filter.filterValue
//
//                        filtersList?.append(restaurantRequestFilter)
//                    }
//                }
//
//                defer {
//                    self.output.send(.fetchSavedFiltersAfterSuccess(filtersSavedList: filtersSavedList ?? []))
//                }
//
//                return filtersList ?? []
//
//            }
//        }
//        return []
//    }
    
    func removeAndSaveFilters(filter: FiltersCollectionViewCellRevampModel) {
        // Remove all saved Filters
        let isFilteredIndex = filtersSavedList?.firstIndex(where: { (restaurantRequestWithNameFilter) -> Bool in
            filter.name.lowercased() == restaurantRequestWithNameFilter.filterName?.lowercased()
        })
        
        if let isFilteredIndex = isFilteredIndex {
            filtersSavedList?.remove(at: isFilteredIndex)
        }
        
        // Remove Names for filters
        let isFilteredNameIndex = filtersList?.firstIndex(where: { (restaurantRequestWithNameFilter) -> Bool in
            filter.filterValue.lowercased() == restaurantRequestWithNameFilter.filterValue?.lowercased()
        })
        
        if let isFilteredNameIndex = isFilteredNameIndex {
            filtersList?.remove(at: isFilteredNameIndex)
        }
        
        self.output.send(.emptyOffersListDidSucceed)
        self.output.send(.fetchAllSavedFiltersSuccess(filtersList: filtersList ?? [], filtersSavedList: filtersSavedList ?? []))
    }
    
    func generateActionContentForSortingItems(sortingModel: GetSortingListResponseModel?) {
        var items = [BaseRowModel]()
        
        if let sortingList = sortingModel?.sortingList, sortingList.count > 0 {
            for (index, sorting) in sortingList.enumerated() {
                if let sortingModel = selectedSortingTableViewCellModel {
                    if sortingModel.name?.lowercased() == sorting.name?.lowercased() {
                        if index == sortingList.count - 1 {
                            addSortingItems(items: &items, sorting: sorting, isSelected: true, isBottomLineHidden: true)
                        } else {
                            addSortingItems(items: &items, sorting: sorting, isSelected: true, isBottomLineHidden: false)
                        }
                    } else {
                        if index == sortingList.count - 1 {
                            addSortingItems(items: &items, sorting: sorting, isSelected: false, isBottomLineHidden: true)
                        } else {
                            addSortingItems(items: &items, sorting: sorting, isSelected: false, isBottomLineHidden: false)
                        }
                    }
                } else {
                    selectedSortingTableViewCellModel = FilterDO()
                    selectedSortingTableViewCellModel = sorting
                    if index == sortingList.count - 1 {
                        addSortingItems(items: &items, sorting: sorting, isSelected: true, isBottomLineHidden: true)
                    } else {
                        addSortingItems(items: &items, sorting: sorting, isSelected: true, isBottomLineHidden: false)
                    }
                }
            }
        }
        
        self.output.send(.fetchContentForSortingItems(baseRowModels: items))
    }
    
    func addSortingItems(items: inout [BaseRowModel], sorting: FilterDO, isSelected: Bool, isBottomLineHidden: Bool) {
//        items.append(SortingTableViewCell.rowModel(model: SortingTableViewCellModel(title: sorting.name.asStringOrEmpty(), mode: .SingleSelection, isSelected: isSelected, multiChoiceUpTo: 1, isSelectionMandatory: true, sortingModel: sorting, bottomLineHidden: isBottomLineHidden)))
    }
}
