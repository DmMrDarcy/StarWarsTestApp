//
//  TabBarView.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import SwiftUI
import Combine

struct TabBarView: View {
    @Binding var currentTab: MainTabs
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            tabFor(.main)
            tabFor(.favorite)
        }
        .frame(height: 70)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.neutralWhite)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
            .ignoresSafeArea())
    }
    
    func tabFor(_ tab: MainTabs) -> some View {
        Button {
            currentTab = tab
        } label: {
            VStack(spacing: 4) {
                tab.icon
                Text(tab.name.localized)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity)
            }
            .foregroundColor(tab == currentTab ? .dark80 : .neutral60)
            .frame(height: 50)
        }

    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            TabBarView(currentTab: .constant(.main))
        }
    }
}
