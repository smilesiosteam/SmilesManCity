//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/07/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities

class QuickAccessViewModel: NSObject {
    
    // MARK: - INPUT/OUTPUT -
    enum Input {
        case getQuickAccessList(categoryId: Int)
    }
    
    enum Output {
        case fetchQuickAccessListDidSucceed(response: QuickAccessResponseModel)
        case fetchQuickAccessListDidFail(error: Error)
    }
    
    // MARK: - PROPERTIES -
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - BINDING -
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getQuickAccessList(let categoryId):
                self?.getQuickAccessList(categoryId: categoryId)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
}

extension QuickAccessViewModel {
    func getQuickAccessList(categoryId: Int) {
        let request = QuickAccessRequestModel(categoryId: categoryId)
        let service = ManCityHomeRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .quickAccessList
        )
        
        service.getQuickAccessListService(request: request)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchQuickAccessListDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                self?.output.send(.fetchQuickAccessListDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}
