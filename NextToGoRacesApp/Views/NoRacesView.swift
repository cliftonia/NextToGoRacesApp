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
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.gray)
                .accessibilityLabel("No races available")
            Text("No races available")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

#if DEBUG
// MARK: - Previews

#Preview {
    NoRacesView()
}
#endif
