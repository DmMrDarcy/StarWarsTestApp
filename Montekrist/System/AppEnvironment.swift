//
//  AppEnvironment.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import UIKit
import Combine

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let appState = Store(AppState())
        let services = configuredServices(appState: appState)
        let diContainer = DIContainer(appState: appState, services: services)

        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredServices(appState: Store<AppState>) -> DIContainer.Services {
        let storageRepo = RealStorageRepo()
        let storageService = StorageService(appState: appState, repo: storageRepo)
        let apiManager = APIManager(environment: appState[\.appData.environment])
        let commonService = DIContainer.CommonService(appState: appState, apiManager: apiManager, storage: storageService)
        
        return .init(storageService: storageService,
                     commonServices: commonService)
        
    }
}

