//
//  ErrorView.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 14.08.2023.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        ZStack {
            Color.black
            
            Image("error")
                .resizable()
                .scaledToFit()
        }
        .frame(width: getRect.width, height: getRect.height)
        .ignoresSafeArea()
    }
}
