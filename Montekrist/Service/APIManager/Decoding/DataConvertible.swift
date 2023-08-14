//
//  DataConvertible.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation

enum DataConvertibleError: Error {
    case couldNotSerialize
}

protocol DataConvertible {
    init(with data: Data) throws
}

public protocol JsonInitiable: Equatable {
    init?(json: NSDictionary)
}
