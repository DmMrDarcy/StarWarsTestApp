//
//  StarWarsModel.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation

// MARK: - StarWarsModel
struct StarWarsModel: Codable {
    let people: [PeopleResult]
    let planets: [PlanetResult]
    let starships: [StarshipResult]
}
