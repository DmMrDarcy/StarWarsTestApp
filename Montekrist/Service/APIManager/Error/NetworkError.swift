//
//  NetworkError.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation

enum NetworkError: Error {
    case code(Int, NetworkErrorData?)
    case error(Error)
    case unknown
    case noInternet
    case serverNotFound
    case timeout
    case unauthorized
}

protocol NetworkErrorble {
    init(with error: NetworkError)
}

extension NetworkError: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .noInternet:
            return "No internet access"
        case .timeout:
            return "Timeout"
        case .unknown:
            return "Unknown error"
        case .serverNotFound:
            return "ServerNotFound"
        case .unauthorized:
            return "Unauthorized error"
        case .error(let error):
            return error.localizedDescription
        case .code(let code, let data):
            return "Code: \(code) data: \(data?.debugDescription ?? "empty")"
        }
    }
}

extension NetworkError {
    init(with error: Error) {
        if let networkError = error as? NetworkError {
            self = networkError
            return
        }
        
        let castedError = error as NSError
        switch castedError.code {
        case NSURLErrorNotConnectedToInternet,
            NSURLErrorDataNotAllowed,
            NSURLErrorCannotConnectToHost,
            NSURLErrorNetworkConnectionLost,
            NSURLErrorTimedOut:
            self = .noInternet
        case NSURLErrorCannotFindHost:
            self = .serverNotFound
        default:
            self = .error(error)
        }
    }

    init?(with response: HTTPURLResponse, data: Data?) {
        let statusCode = response.statusCode

        switch statusCode {
        case 200 ..< 300:
            return nil
        case 504:
            self = NetworkError.timeout
        case 502:
            self = NetworkError.unknown
        case 401:
            self = NetworkError.unauthorized
        case 400, 403, 404, 500:
            var errorData: NetworkErrorData?
            if let data = data {
                errorData = try? NetworkErrorData(with: data)
            }
            self = NetworkError.code(statusCode, errorData)
        default:
            self = NetworkError.unknown
        }
    }
    
}

extension NetworkError: NetworkErrorble {
    init(with error: NetworkError) {
        self = error
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.code(let codeLhs, _), .code(let codeRhs, _)):
            return codeLhs == codeRhs
        case (.error(let errorLhs), .error(let errorRhs)):
            return errorLhs.localizedDescription == errorRhs.localizedDescription
        case (.unknown, .unknown):
            return true
        case (.noInternet, .noInternet):
            return true
        case (.serverNotFound, .serverNotFound):
            return true
        case (.timeout, .timeout):
            return true
        case (.unauthorized, .unauthorized):
            return true
        case (.code, _), (.error, _), (.unknown, _), (.noInternet, _), (.serverNotFound, _), (.timeout, _), (.unauthorized, _):
            return false
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .code(_, let networkErrorData):
            return networkErrorData?.message
        case .error(let error):
            return error.localizedDescription
        case .unknown:
            return "unknown_error".localized
        case .noInternet:
            return "apihelper_no_connection".localized
        case .serverNotFound:
            return ""
        case .timeout:
            return "apihelper_request_timeout".localized
        case .unauthorized:
            return "apihelper_no_user".localized
        }
    }
}

