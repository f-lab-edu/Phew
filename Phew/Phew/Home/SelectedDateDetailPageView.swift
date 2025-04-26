//
//  SelectedDateDetailPageView.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI

struct SelectedDateDetailPageView: View {
    let date: Date

    var body: some View {
        VStack {
            Text("selected date: \(date)")
                .font(.title)
                .padding()
            Spacer()
        }
    }
}
