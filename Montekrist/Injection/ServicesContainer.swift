//
//  ServicesContainer.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

extension DIContainer {
    struct Services {
        let storageService: StorageService
        let commonServices: CommonService
        
        init(storageService: StorageService,
             commonServices: CommonService
        ) {
            self.storageService = storageService
            self.commonServices = commonServices
        }
        
        static var stub: Self {
            .init(storageService: StorageService(appState: .init(.preview), repo: RealStorageRepo()),
                  commonServices: CommonService.stub
            )
        }
    }
}

