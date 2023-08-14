//
//  RequestParameters.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Alamofire
enum RequestParameters {
    case standard(parameters: Parameters?, encoding: NetworkParameterEncoding)
}

enum NetworkParameterEncoding {
    case url
    case json
}

extension NetworkParameterEncoding {
    var alamofireEncoding: ParameterEncoding {
        switch self {
        case .json:
            return JSONEncoding.default
        case .url:
            return URLEncoding.default
        }
    }
}

