//
//  SearchFieldView.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import SwiftUI

struct SearchFieldView: View {
    @Binding var searchText: String
    var perform: ()->()
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.neutral60)
            
            TextField("search_placeholder".localized, text: $searchText, onCommit: {
                if searchText.count >= 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        perform()
                    }
                }
            })
        }
        .font(.body)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.neutralWhite)
                .shadow(color: Color.neutral30,
                    radius: 10, x: 0, y: 0)
        )
    }
}
