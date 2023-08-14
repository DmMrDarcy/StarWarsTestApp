//
//  Config.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation

public enum Config {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let appVersion: String = {
        guard let value = Config.infoDictionary["CFBundleShortVersionString"] as? String else {
            fatalError("App Version not set in plist for this environment")
        }
        return value
    }()
}

// MARK: - Links
extension Config {
    enum EndPoint: String, Codable {
        case dev
        case prod
        
        var name: String {
            switch self {
            case .prod:
                return "Prod"
            case .dev:
                return "Dev"
            }
        }
        
        var url: URL {
            switch self {
            case .prod:
                return URL(string: Hosts.live)!
            case .dev:
                return URL(string: Hosts.live)!
            }
        }
    }
    
    public struct Hosts {
        // Live
        public static let live = "https://swapi.dev/api/"
    }
}
