//
//  AppTabView.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import SwiftUI
import SwiftData

struct AppTabView: View {
    @Binding var selection: AppScreen?
        
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreen?)
                    .tabItem { screen.label }
            }
        }
    }
}
