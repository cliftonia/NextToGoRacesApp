//
//  NoRacesView.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 15/02/2025.
//

import SwiftUI

/// This view displays a message indicating that no races are available.
///
/// The view shows a gray exclamation mark icon and a headline text stating "No races available."
struct NoRacesView: View {
    var body: some View {
        VStack(spacing: .NextToGoRacesSpacing.defaultSpacing) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.gray)
                .accessibilityLabel("No races available")
                .accessibilityHidden(true)
            Text("No races available")
                .font(.headline)
                .foregroundColor(.gray)
                .accessibilityLabel("No races available. Check back later.")
        }
        .padding()
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
// MARK: - Previews

#Preview {
    NoRacesView()
}
#endif
