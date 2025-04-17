//
//  RageButtonClickTimeHistoryView.swift
//  Phew
//
//  Created by dong eun shin on 4/11/25.
//

import SwiftUI
import SwiftData

struct RageButtonClickTimeHistoryView: View {
    @Query(sort: \RageButtonClickTime.startedAt) private var rageButtonClickTimeRecords: [RageButtonClickTime]
    @Environment(\.modelContext) private var context

    public var body: some View {
        NavigationStack {
            List {
                ForEach(rageButtonClickTimeRecords) { rageButtonClickTimeRecord in
                    let duration = rageButtonClickTimeRecord.endedAt.timeIntervalSince(rageButtonClickTimeRecord.startedAt)
                    
                    Text("\(duration)")
                }
            }
            .navigationTitle("History")
        }
    }
}
