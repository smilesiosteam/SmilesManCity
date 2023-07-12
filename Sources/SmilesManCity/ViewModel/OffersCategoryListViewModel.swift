//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 11/07/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities

class OffersCategoryListViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    enum Input {
        case getOffersCategoryList(pageNo: Int, categoryId: String, searchByLocation: Bool, sortingType: String?, subCategoryId: String, subCategoryTypeIdsList: [String]?)
    }
    
    enum Output {
        case fetchOffersCategoryListDidSucceed(response: OffersCategoryResponseModel)
        case fetchOffersCategoryListDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
}

extension OffersCategoryListViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getOffersCategoryList(let pageNo, let categoryId, let searchByLocation, let sortingType, let subCategoryId, let subCategoryTypeIdsList):
                self?.getOffersCategoryList(pageNo: pageNo, categoryId: categoryId, searchByLocation: searchByLocation, sortingType: sortingType, subCategoryId: subCategoryId, subCategoryTypeIdsList: subCategoryTypeIdsList)
                
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func getOffersCategoryList(pageNo: Int, categoryId: String, searchByLocation: Bool, sortingType: String?, subCategoryId: String = "1", subCategoryTypeIdsList: [String]?) {
        let offersCategoryRequest = OffersCategoryRequestModel(pageNo: pageNo, categoryId: categoryId, searchByLocation: searchByLocation,  sortingType: sortingType, subCategoryId: subCategoryId, subCategoryTypeIdsList: subCategoryTypeIdsList, isGuestUser: AppCommonMethods.isGuestUser)
        
        let service = GetOffersCategoryListRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .offersCategoryList
        )
        
        service.getOffersCategoryListService(request: offersCategoryRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchOffersCategoryListDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.fetchOffersCategoryListDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}
