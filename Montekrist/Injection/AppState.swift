//
//  AppState.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation

struct AppState: Equatable {
    var appData = AppData()
    var routing = Routing()
}

extension AppState {
    struct AppData: Equatable {
        var environment: EnvironmentData = EnvironmentData()
        var favoritePeople: [PeopleResult] = []
        var favoriteStarship: [StarshipResult] = []
        var favoritePlanet: [PlanetResult] = []
    }
}

extension AppState {
    struct Routing: Equatable {
        var currentRoute: AppRouting = .splash
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    lhs.appData == rhs.appData
        && lhs.routing == rhs.routing
}

extension AppState {
    static var preview: AppState {
        let state = AppState()
        return state
    }
}

