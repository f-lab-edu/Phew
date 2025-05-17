//
//  AppTabView.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import ComposableArchitecture
import PhewComponent
import SwiftUI

struct AppTabView: View {
    let store: StoreOf<AppTabFeature>
    @ObservedObject var viewStore: ViewStoreOf<AppTabFeature>

    init(store: StoreOf<AppTabFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }

    var body: some View {
        TabView(selection: viewStore.binding(
            get: \.selectedTab,
            send: AppTabFeature.Action.selectTab
        )) {
            HomeView(store: store.scope(state: \.home, action: \.home))
                .tag(AppTabFeature.Tab.home)
                .tabItem { Label("Home", systemImage: "house") }

            StatusView(store: store.scope(state: \.status, action: \.status))
                .tag(AppTabFeature.Tab.status)
                .tabItem { Label("status", systemImage: "checkmark.circle") }

            AccountView(store: store.scope(state: \.account, action: \.account))
                .tag(AppTabFeature.Tab.account)
                .tabItem {  Label("Account", systemImage: "person.crop.circle") }
        }
        .tint(PhewColor.primaryGreen)
    }
}
