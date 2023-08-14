//
//  Localize.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation

// MARK: - Locale
extension String {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(_ locale: Locale) -> String {
        let localeId = locale.shortIdentifier
        guard let path = Bundle.main.path(forResource: localeId, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return self.localized
        }
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
