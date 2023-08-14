//
//  MainView.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import SwiftUI
import Combine

struct MainView: View {
    @StateObject var vm: ViewModel
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $vm.curretTab.animation()) {
                ZStack {
                    main
                    
                    if vm.showError {
                        ErrorView()
                    }
                }
                .onDisappear {
                    vm.clearSearch()
                }
                .tag(MainTabs.main)
                
                FavoritesView(vm: .init(container: vm.container))
                    .tag(MainTabs.favorite)
            }
            
            TabBarView(currentTab: $vm.curretTab.animation())
        }
    }
    
    var main: some View {
        VStack(spacing: 0) {
            SearchFieldView(searchText: $vm.searchText, perform: vm.getStarWars)
            
            Spacer()
            
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
    }
    
    var personList: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(vm.peopleResult.indices, id: \.self) { index in
                    let item = vm.peopleResult[index]
                    StarWarsItemView(pageType: .main,
                                     type: .people,
                                     personParams: (name: item.name,
                                                    sex: item.gender,
                                                    starshipCount: String(item.starships.count)),
                                     addToFavorite: {vm.addPeopleToFavorite(peopleItem: item, index: index)},
                                     isFavorite: vm.favoritePeople.count > 0 ? vm.favoritePeople[index] : false)
                }
            }
            .padding()
        }
    }
    
    var starshipList: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(vm.starshipResult.indices, id: \.self) { index in
                    let item = vm.starshipResult[index]
                    StarWarsItemView(pageType: .main,
                                     type: .starship,
                                     starshipParams: (name: item.name,
                                                      model: item.model,
                                                      manufacturer: item.manufacturer,
                                                      passengers: item.passengers),
                                     addToFavorite: {vm.addStarshipToFavorite(starshipItem: item, index: index)},
                                     isFavorite: vm.favoriteStarship.count > 0 ? vm.favoriteStarship[index] : false)
                }
            }
            .padding()
        }
    }
    
    var planetList: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(vm.planetResult.indices, id: \.self) { index in
                    let item = vm.planetResult[index]
                    StarWarsItemView(pageType: .main,
                                     type: .planet,
                                     planetParams: (name: item.name,
                                                    diameter: item.diameter,
                                                    population: item.population),
                                     addToFavorite: {vm.addPlanetToFavorite(planetItem: item, index: index)},
                                     isFavorite: vm.favoriteStarship.count > 0 ? vm.favoritePlanet[index] : false)
                }
            }
            .padding()
        }
    }
}

extension MainView {
    class ViewModel: ObservableObject {
        @Published var curretTab: MainTabs = .main
        @Published var searchText = ""
        @Published var showError: Bool = false
        
        @Published var peopleResult: [PeopleResult] = []
        @Published var starshipResult: [StarshipResult] = []
        @Published var planetResult: [PlanetResult] = []
        
        @Published var favoritePeople: [Bool] = []
        @Published var favoriteStarship: [Bool] = []
        @Published var favoritePlanet: [Bool] = []
        let container: DIContainer
        private let cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
        }
        
        func getStarWars() {
            container.services.commonServices.getStarWars(query: searchText)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] complition in
                    guard let self = self else {return}
                    switch complition {
                    case .failure(_):
                        self.showError = true
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] result in
                    guard let self = self else {return}
                    self.peopleResult = result.people.results
                    self.starshipResult = result.starships.results
                    self.planetResult = result.planets.results
                    
                    self.favoritePeople = Array(repeating: false, count: self.peopleResult.count)
                    self.favoriteStarship = Array(repeating: false, count: self.starshipResult.count)
                    self.favoritePlanet = Array(repeating: false, count: self.planetResult.count)
                }
                .store(in: cancelBag)
        }
        
        func addPeopleToFavorite(peopleItem: PeopleResult, index: Int) {
            let favoritePeopleArray = container.appState[\.appData.favoritePeople]
            if  favoritePeopleArray.contains(where: {$0.name == peopleItem.name}) {
                return
            }
            
            favoritePeople[index] = true
            container.appState[\.appData.favoritePeople].append(peopleItem)
        }
        
        func addStarshipToFavorite(starshipItem: StarshipResult, index: Int) {
            let favoriteStarshipArray = container.appState[\.appData.favoriteStarship]
            if  favoriteStarshipArray.contains(where: {$0.name == starshipItem.name}) {
                return
            }
            
            favoriteStarship[index] = true
            container.appState[\.appData.favoriteStarship].append(starshipItem)
        }
        
        func addPlanetToFavorite(planetItem: PlanetResult, index: Int) {
            let favoritePlanetArray = container.appState[\.appData.favoritePlanet]
            if  favoritePlanetArray.contains(where: {$0.name == planetItem.name}) {
                return
            }
            
            favoritePlanet[index] = true
            container.appState[\.appData.favoritePlanet].append(planetItem)
        }
        
        func clearSearch() {
            showError = false
            peopleResult = []
            starshipResult = []
            planetResult = []
            searchText = ""
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(vm: .init(container: .preview))
    }
}
