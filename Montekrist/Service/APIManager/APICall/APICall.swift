//
//  APICall.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation
import Alamofire

protocol APICall {
    var parameters: RequestParameters {get}
    var path: String {get}
    var httpMethod: HTTPMethod {get}
    func createURLConvertible(baseURL: URL) -> String
}

extension APICall {
    func createURLConvertible(baseURL: URL) -> String {
        return "\(baseURL)/\(path)"
    }
}

enum APIMethods {
    case people(query: String)
    case planets(query: String)
    case starships(query: String)
}

extension APIMethods: APICall {
    var parameters: RequestParameters {
        switch self {
        case .people(let query):
            let parameters: [String: Any] = ["search": query]
            return .standard(parameters: parameters, encoding: .url)
        case .planets(let query):
            let parameters: [String: Any] = ["search": query]
            return .standard(parameters: parameters, encoding: .url)
        case .starships(let query):
            let parameters: [String: Any] = ["search": query]
            return .standard(parameters: parameters, encoding: .url)
        }
    }
    
    var path: String {
        switch self {
        case .people:
            return "people/"
        case .planets:
            return "planets/"
        case .starships:
            return "starships/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .people, .planets, .starships:
            return .get
        }
    }
    
}

