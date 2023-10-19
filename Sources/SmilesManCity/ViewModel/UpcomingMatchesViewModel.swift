//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 27/07/2023.
//

import Foundation
import Combine
import SmilesSharedServices
import SmilesUtilities
import NetworkingLayer
import SmilesOffers

class UpcomingMatchesViewModel: NSObject {
    
    // MARK: - PROPERTIES -
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - VIEWMODELS -
    private let sectionsViewModel = SectionsViewModel()
    
    private var sectionsUseCaseInput: PassthroughSubject<SectionsViewModel.Input, Never> = .init()
    private var offersCategoryListUseCaseInput: PassthroughSubject<OffersCategoryListViewModel.Input, Never> = .init()
}

// MARK: - VIEWMODELS BINDINGS -
extension UpcomingMatchesViewModel {
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getSections(categoryID: let categoryID):
                self?.bind(to: self?.sectionsViewModel ?? SectionsViewModel())
                self?.sectionsUseCaseInput.send(.getSections(categoryID: categoryID, baseUrl: AppCommonMethods.serviceBaseUrl, isGuestUser: AppCommonMethods.isGuestUser, type: "UPDATES"))
                
            case .getTeamRankings:
                self?.getTeamRankings()
                
            case .getTemNews:
                self?.getTeamNews()
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
    
    
    func getTeamRankings() {
        
        let teamRankingRequest = TeamRankingRequest()

        let service = UpcomingMatchesRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .getTeamRankingInfo)

        service.getTeamRankingsService(request: teamRankingRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchTeamRankingsDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.fetchTeamRankingsDidSucceed(response: response))
            }
        .store(in: &cancellables)
        
    }
    
    func getTeamNews() {
        
        let teamNewsRequest = TeamNewsRequest()

        let service = UpcomingMatchesRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .getTeamNewsInfo)

        service.getTeamNewsService(request: teamNewsRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchTeamNewsDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.fetchTeamNewsDidSucceed(response: response))
            }
        .store(in: &cancellables)
        
    }
    
}
