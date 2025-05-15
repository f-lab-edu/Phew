//
//  ContentView.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
	let store: StoreOf<AppFeature>
	@ObservedObject var viewStore: ViewStoreOf<AppFeature>

	init(store: StoreOf<AppFeature>) {
		self.store = store
		viewStore = ViewStore(store, observe: { $0 })
	}

	var body: some View {
		Group {
			switch store.destination {
			case .none:
				AppTabView(store: store.scope(state: \.appTab, action: \.appTab))
			}
		}
	}
}

#Preview {
	ContentView(
		store: .init(
			initialState: AppFeature.State.init(),
			reducer: {
				AppFeature()
			}
        )
    )
}
