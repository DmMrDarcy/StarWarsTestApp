//
//  EnvironmentData.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation

struct EnvironmentData: Codable, Equatable {
    var endPoint: Config.EndPoint = .dev
}
