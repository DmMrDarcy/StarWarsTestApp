//
//  CommonService.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Alamofire
import Combine
import SwiftUI

protocol CommonServiceProtocol: AnyObject {
    func getStarWars(query: String) -> AnyPublisher<StarWarsModel, NetworkError>
    func getFavorite() -> AnyPublisher<StarWarsModel, Never>
}

extension DIContainer {
    class CommonService: CommonServiceProtocol {
        private let appState: Store<AppState>
        private let apiManager: APIManager
        private let storage: StorageService
        private var cancelBag = CancelBag()
        
        init(appState: Store<AppState>, apiManager: APIManager, storage: StorageService) {
            self.appState = appState
            self.apiManager = apiManager
            self.storage = storage
        }
        
        func getStarWars(query: String) -> AnyPublisher<StarWarsModel, NetworkError> {
            let peoplePublisher: AnyPublisher<PeopleModel, NetworkError> =
            apiManager.call(apiMethod: .people(query: query))
            
            let planetPublisher: AnyPublisher<PlanetModel, NetworkError> =
            apiManager.call(apiMethod: .planets(query: query))
            
            let starshipPublisher: AnyPublisher<StarshipModel, NetworkError> =
            apiManager.call(apiMethod: .starships(query: query))
            
            return Publishers.CombineLatest3(peoplePublisher, planetPublisher, starshipPublisher)
                .map { people, planets, starships in
                    return StarWarsModel(people: people.results, planets: planets.results, starships: starships.results)
                }
                .eraseToAnyPublisher()
        }
        
        func getFavorite() -> AnyPublisher<StarWarsModel, Never> {
            let favoritePeople = appState[\.appData.favoritePeople]
            let favoriteStarship = appState[\.appData.favoriteStarship]
            let favoritePlanet = appState[\.appData.favoritePlanet]
            
            let mergedData = StarWarsModel(people: favoritePeople, planets: favoritePlanet, starships: favoriteStarship)
                return Just(mergedData)
                    .eraseToAnyPublisher()
        }
        
        static let stub: CommonService = {
            let appState = Store(AppState())
            let repo = RealStorageRepo()
            let apiManager = APIManager(environment: appState[\.appData.environment])
            let storageService = StorageService(appState: .init(.preview), repo: repo)
            
            return CommonService(appState: .init(.preview), apiManager: apiManager, storage: storageService)
        }()
    }
}
