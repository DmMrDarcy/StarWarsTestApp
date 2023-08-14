//
//  NetworkConfiguration.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation
import Alamofire

class NetworkConfiguration {
    let defaultHttpHeaders: HTTPHeaders
    var endPoint: Config.EndPoint?

    init(endPoint: Config.EndPoint, headers: HTTPHeaders = [:]) {
        self.defaultHttpHeaders = headers
        self.endPoint = endPoint
    }

    var baseURL: URL? {
        endPoint?.url
    }
}

