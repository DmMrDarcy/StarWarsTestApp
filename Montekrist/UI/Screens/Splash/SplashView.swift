//
//  SplashView.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import SwiftUI
import Combine

struct SplashView: View {
    @StateObject var vm: ViewModel
    var body: some View {
        ZStack {
            Color.black
            
            Image("splashLogo")
        }
        .frame(width: getRect.width, height: getRect.height)
        .scaledToFill()
        .ignoresSafeArea()
    }
}

extension SplashView {
    class ViewModel: ObservableObject {
        let container: DIContainer
        private let cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                container.appState[\.routing.currentRoute] = .main
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(vm: .init(container: .preview))
    }
}

