//
//  StarWarsItem.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import SwiftUI

enum StarWarsType {
    case people
    case starship
    case planet
}

enum PageType {
    case main
    case favorite
}

struct StarWarsItemView: View {
    var pageType: PageType
    var type: StarWarsType
    var personParams: (name: String, sex: String, starshipCount: String) = (name: "", sex: "", starshipCount: "")
    var starshipParams: (name: String, model: String, manufacturer: String, passengers: String) = (name: "", model: "", manufacturer: "", passengers: "")
    var planetParams: (name: String, diameter: String, population: String) = (name: "", diameter: "", population: "")
    var addToFavorite: ()->() = {}
    var isFavorite: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                HStack(spacing: 0) {
                    Text(firstFieldTitle.localized)
                    Spacer()
                    Text(firstFieldValue)
                        .multilineTextAlignment(.trailing)
                }
                HStack(spacing: 10) {
                    Text(secondFieldTitle.localized)
                    Spacer()
                    Text(secondFieldValue)
                        .multilineTextAlignment(.trailing)
                }
                HStack(spacing: 10) {
                    Text(thirdFieldTitle.localized)
                    Spacer()
                    Text(thirdFieldValue)
                        
                        .multilineTextAlignment(.trailing)
                }
                if type == .starship {
                    HStack(spacing: 10) {
                        Text("starship_passengers".localized)
                        Spacer()
                        Text(starshipParams.passengers)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                if pageType == .main {
                    HStack(spacing: 10) {
                        Text("star_wars_item_add_to_favorite".localized)
                        Spacer()
                        
                        Button(action: {
                            addToFavorite()
                        }) {
                            Image(systemName: isFavorite ? "star.fill" : "star" )
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(isFavorite ? .blue40 : .dark100)
                        }
                    }
                }
            }
            .font(.caption)
            .lineLimit(3)
            .minimumScaleFactor(0.85)
            .fixedSize(horizontal: false, vertical: true)
            .padding(10)
        }
        .frame(maxWidth: 500, maxHeight: 220, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.neutralWhite)
                .shadow(color: Color.neutral30,
                    radius: 10, x: 0, y: 0)
        )
        .frame(width: 270)
    }
    
    var firstFieldTitle: String {
        switch type {
        case .people:
            return "person_name"
        case .starship:
            return "starship_name"
        case .planet:
            return "planet_name"
        }
    }
    
    var secondFieldTitle: String {
        switch type {
        case .people:
            return "person_gender"
        case .starship:
            return "starship_model"
        case .planet:
            return "planet_diameter"
        }
    }
    
    var thirdFieldTitle: String {
        switch type {
        case .people:
            return "person_starship_count"
        case .starship:
            return "starship_manufacturer"
        case .planet:
            return "planet_population"
        }
    }
    
    var firstFieldValue: String {
        switch type {
        case .people:
            return personParams.name
        case .starship:
            return starshipParams.name
        case .planet:
            return planetParams.name
        }
    }
    
    var secondFieldValue: String {
        switch type {
        case .people:
            return personParams.sex
        case .starship:
            return starshipParams.model
        case .planet:
            return planetParams.diameter
        }
    }
    
    var thirdFieldValue: String {
        switch type {
        case .people:
            return personParams.starshipCount
        case .starship:
            return starshipParams.manufacturer
        case .planet:
            return planetParams.population
        }
    }
}

struct StarWarsItemView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isFavorite: Bool = false
        StarWarsItemView(pageType: .main, type: .starship, starshipParams: (name: "asdfasdf asdf", model: "sasdf dsf", manufacturer: "dsfdfs dsffds dsffds sdf sdfdfs d", passengers: "20") )
    }
}
