//
//  File.swift
//  
//
//  Created by Shmeel Ahmed on 01/08/2023.
//


import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities
import SmilesOffers
import SmilesBaseMainRequestManager

class ManCityInviteFriendsViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    enum Input {
        case fetchInviteFriendsData
    }
    
    enum Output {
        case getInviteFriendsDataDidSucceed(response: InviteFriendsResponse)
        case getInviteFriendsDataDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
}

extension ManCityInviteFriendsViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .fetchInviteFriendsData:
                self?.fetchInviteFriendsData()
                
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func fetchInviteFriendsData() {
        let offersCategoryRequest = SmilesBaseMainRequest()
        
        let service = InviteFriendsRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .fetchInviteFriendsData
        )
        
        service.InviteFriendsService(request: offersCategoryRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.getInviteFriendsDataDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.getInviteFriendsDataDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}
