//
//  NetworkErrorData.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation

struct NetworkErrorData: Decodable, DataConvertible {
    var code: Int
    var message: String?

    private enum CodingKeys: String, CodingKey {
        case code
        case message
    }
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let code = try? container.decode(Int.self, forKey: .code) {
            self.code = code
        } else if let codeString = try? container.decode(String.self, forKey: .code), let code = Int(codeString) {
            self.code = Int(code)
        } else {
            self.code = try container.decode(Int.self, forKey: .code)
        }
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}

extension NetworkErrorData: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Network Error Data code: \(code) message: \(message ?? "empty")"
    }
}

