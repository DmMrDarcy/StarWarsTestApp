//
//  ContentView.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        ZStack {
            Group {
                switch viewModel.currentRoute {
                case .splash:
                    SplashView(vm: .init(container: viewModel.container))
                case .main:
                    MainView(vm: .init(container: viewModel.container))
                }
            }
            .transition(.push(from: .trailing))
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var currentRoute: AppRouting = .splash
        let container: DIContainer
        private let cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
            
            container.appState
                .map(\.routing.currentRoute)
                .removeDuplicates()
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] rote in
                    guard let self else { return }
                    withAnimation {
                        self.currentRoute = rote
                    }
                }
                .store(in: cancelBag)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(container: .preview))
    }
}
