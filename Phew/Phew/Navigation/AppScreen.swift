//
//  AppScreen.swift
//  Phew
//
//  Created by dong eun shin on 4/23/25.
//

import SwiftUI

enum AppScreen: Codable, Hashable, Identifiable, CaseIterable {
    case calendar
    case status
    case account
    
    var id: AppScreen { self }
}

extension AppScreen {
    @ViewBuilder
    var label: some View {
        switch self {
        case .calendar:
            Label("calender", systemImage: "calendar")
        case .status:
            Label("status", systemImage: "checkmark.circle")
        case .account:
            Label("Account", systemImage: "person.crop.circle")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .calendar:
            HomeView()
        case .status:
            StatusView()
        case .account:
            AccountView()
        }
    }
}
