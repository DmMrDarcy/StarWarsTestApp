//
//  Helpers.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation

extension Locale {
    var shortIdentifier: String {
        return String(identifier.prefix(2))
    }
}
