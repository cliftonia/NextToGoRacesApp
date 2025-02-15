//
//  ErrorView.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 15/02/2025.
//

import SwiftUI

/// This view displays an error message based on a `RaceViewModelError`.
///
/// It shows a red exclamation mark icon along with the localized description
/// of the error in a vertically stacked layout. This presentation provides
/// clear and accessible feedback to the user when an error occurs.
///
/// - Properties:
///   - error: The `RaceViewModelError` instance whose localized description is shown.
struct ErrorView: View {
    let error: RaceViewModelError
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
                .accessibilityLabel("Error")
            
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#if DEBUG
// MARK: - Previews

#Preview("Invalid URL") {
    ErrorView(error: .serviceError(.invalidURL))
}

#Preview("Invalid Response") {
    ErrorView(error: .serviceError(.invalidResponse))
}

#Preview("HTTP Error (404)") {
    ErrorView(error: .serviceError(.httpError(statusCode: 404)))
}

#Preview("Unknown Error") {
    ErrorView(error: .unknown(NSError(domain: "TestDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "An unknown error occurred."])))
}
#endif
