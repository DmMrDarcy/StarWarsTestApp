//
//  Extensions.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation
import SwiftUI

extension Data {
    func decode<T: Decodable>(_ type: T.Type) -> T? {
        let decoder = JSONDecoder()
        
        return try? decoder.decode(T.self, from: self)
    }
}

extension Encodable {
    var data: Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let data = try? encoder.encode(self) else { return Data() }

        return data
    }
}

extension DataConvertible where Self: Decodable {
    init(with data: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }
}

extension View {
    var getRect: CGRect {
        return UIScreen.main.bounds
    }
}

extension Color {
    public static let neutralWhite = Asset.neutralWhite.swiftUIColor
    public static let neutral30 = Asset.neutral30.swiftUIColor
    public static let neutral60 = Asset.neutral60.swiftUIColor
    public static let blue40 = Asset.blue40.swiftUIColor
    public static let dark60 = Asset.dark60.swiftUIColor
    public static let dark80 = Asset.dark80.swiftUIColor
    public static let dark100 = Asset.dark100.swiftUIColor
}
