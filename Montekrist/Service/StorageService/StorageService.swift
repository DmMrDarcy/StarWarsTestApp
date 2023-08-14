//
//  StorageService.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation
import SwiftUI

class StorageService {
    
    private let appState: Store<AppState>
    private var cancelBag = CancelBag()
    private var repo: StorageRepo
    
    init(appState: Store<AppState>, repo: StorageRepo) {
        self.appState = appState
        self.repo = repo
        
        environmentLoad()
        installObservers()
    }
    private func environmentLoad() {
        var environment = EnvironmentData()

        #if RELEASE
        environment.endPoint = .prod
        #endif

        repo.environmentData = environment
        appState[\.appData.environment] = environment
        
        appState[\.appData.favoritePeople] = repo.favoritePeople
        appState[\.appData.favoriteStarship] = repo.favoriteStarship
        appState[\.appData.favoritePlanet] = repo.favoritePlanet
    }

    private func installObservers() {
        cancelBag.collect {
            appState.map(\.appData.environment)
                .removeDuplicates()
                .dropFirst()
                .sink { [unowned self] in
                    repo.environmentData = $0
                }
            
            appState.map(\.appData.favoritePeople)
                .removeDuplicates()
                .dropFirst()
                .sink { [unowned self] in
                    repo.favoritePeople = $0
                }
            
            appState.map(\.appData.favoriteStarship)
                .removeDuplicates()
                .dropFirst()
                .sink { [unowned self] in
                    repo.favoriteStarship = $0
                }
            
            appState.map(\.appData.favoritePlanet)
                .removeDuplicates()
                .dropFirst()
                .sink { [unowned self] in
                    repo.favoritePlanet = $0
                }
        }
    }
}

