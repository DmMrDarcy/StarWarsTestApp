//
//  Favorites.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import SwiftUI
import Combine

struct FavoritesView: View {
    @StateObject var vm: ViewModel
    var body: some View {
        favorites
    }
    
    var favorites: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                if vm.peopleResult.count > 0 {
                    Text("main_people_title".localized)
                        .font(.title3)
                    
                    personList
                }
                
                if vm.starshipResult.count > 0 {
                    Text("main_starship_title".localized)
                        .font(.title3)
                    
                    starshipList
                }
                
                if vm.planetResult.count > 0 {
                    Text("main_planet_title".localized)
                        .font(.title3)
                    
                    planetList
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            vm.getFavorites()
        }
    }
    
    var personList: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(0..<vm.peopleResult.count, id: \.self) { index in
                    StarWarsItemView(pageType: .favorite,
                                     type: .people,
                                     personParams: (name: vm.peopleResult[index].name,
                                                    sex: vm.peopleResult[index].gender,
                                                    starshipCount: String(vm.peopleResult[index].starships.count)))
                }
            }
            .padding()
        }
    }
    
    var starshipList: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(0..<vm.starshipResult.count, id: \.self) { index in
                    StarWarsItemView(pageType: .favorite,
                                     type: .starship,
                                     starshipParams: (name: vm.starshipResult[index].name,
                                                      model: vm.starshipResult[index].model,
                                                      manufacturer: vm.starshipResult[index].manufacturer,
                                                      passengers: vm.starshipResult[index].passengers))
                }
            }
            .padding()
        }
    }
    
    var planetList: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(0..<vm.planetResult.count, id: \.self) { index in
                    StarWarsItemView(pageType: .favorite,
                                     type: .planet,
                                     planetParams: (name: vm.planetResult[index].name,
                                                    diameter: vm.planetResult[index].diameter,
                                                    population: vm.planetResult[index].population))
                }
            }
            .padding()
        }
    }
}

extension FavoritesView {
    class ViewModel: ObservableObject {
        @Published var peopleResult: [PeopleResult] = []
        @Published var starshipResult: [StarshipResult] = []
        @Published var planetResult: [PlanetResult] = []
        @Published var isFavorite: Bool = false
        let container: DIContainer
        private let cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
        }
        
        func getFavorites() {
            container.services.commonServices.getFavorite()
                .receive(on: DispatchQueue.main)
                .sink { _ in } receiveValue: { [weak self] result in
                    guard let self = self else {return}
                    self.peopleResult = result.people
                    self.starshipResult = result.starships
                    self.planetResult = result.planets
                }
                .store(in: cancelBag)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(vm: .init(container: .preview))
    }
}
