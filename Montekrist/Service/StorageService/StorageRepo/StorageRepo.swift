//
//  StorageRepo.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//
import Foundation
import SwiftUI

private enum ConstantsLocal: String, CaseIterable {
    case environmentKey = "environmentData"
    case favoritePeople = "favoritePeople"
    case favoriteStarship = "favoriteStarship"
    case favoritePlanet = "favoritePlanet"
}

protocol StorageRepo {
    var environmentData: EnvironmentData? {get set}
    var favoritePeople: [PeopleResult] {get set}
    var favoriteStarship: [StarshipResult] {get set}
    var favoritePlanet: [PlanetResult] {get set}
}

class RealStorageRepo: StorageRepo {
    var environmentData: EnvironmentData? {
        get {
            return envData.decode(EnvironmentData.self)
        }
        set {
            envData = newValue.data
        }
    }
    var favoritePeople: [PeopleResult] {
        get {
            return favoritePeopleData.decode([PeopleResult].self) ?? []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                favoritePeopleData = encoded
            }
        }
    }
    var favoriteStarship: [StarshipResult] {
        get {
            return favoriteStarshipData.decode([StarshipResult].self) ?? []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                favoriteStarshipData = encoded
            }
        }
    }
    var favoritePlanet: [PlanetResult] {
        get {
            return favoritePlanetData.decode([PlanetResult].self) ?? []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                favoritePlanetData = encoded
            }
        }
    }
    
    // MARK: - AppData
    @AppStorage(ConstantsLocal.environmentKey.rawValue) private var envData: Data = Data()
    @AppStorage(ConstantsLocal.favoritePeople.rawValue) private var favoritePeopleData: Data = Data()
    @AppStorage(ConstantsLocal.favoriteStarship.rawValue) private var favoriteStarshipData: Data = Data()
    @AppStorage(ConstantsLocal.favoritePlanet.rawValue) private var favoritePlanetData: Data = Data()
}
