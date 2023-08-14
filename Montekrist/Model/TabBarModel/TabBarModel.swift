//
//  TabBarModel.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation
import SwiftUI

enum MainTabs {
    case main
    case favorite
    
    var icon: Image {
            switch self {
            case .main:
                return Image(systemName: "house")
                    .renderingMode(.template)
            case .favorite:
                return Image(systemName: "star")
                    .renderingMode(.template)
            }
        
    }
    
    var colorOn: Color {
        return .blue40
    }
    
    var colorOff: Color {
        return .neutral30
    }
    
    var name: String {
        switch self {
        case .main:
            return "tabbar_main"
        case .favorite:
            return "tabbar_favorite"
        }
    }
}
