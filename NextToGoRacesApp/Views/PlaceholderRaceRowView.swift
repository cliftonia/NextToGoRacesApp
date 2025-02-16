//
//  PlaceholderRaceRowView.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 15/02/2025.
//

import SwiftUI

/// This view displays a placeholder race row when no race data is available.
///
/// It shows default text and a placeholder countdown to indicate upcoming race data.
struct PlaceholderRaceRowView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("No Race")
                    .font(.headline)
                Text("Upcoming race...")
                    .font(.subheadline)
            }
            Spacer()
            Text("--:--")
                .font(.system(.body, design: .monospaced))
        }
        .padding()
        .foregroundColor(.gray)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("No race available. Awaiting next race.")
    }
}

#if DEBUG
// MARK: - Previews

#Preview {
    PlaceholderRaceRowView()
}
#endif
