//
//  RaceInfoView.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 15/02/2025.
//

import SwiftUI

/// This view displays detailed race information including the meeting name,
/// race number, and race category (with an emoji).
///
/// - Properties:
///   - race: A `Race` object containing the information to be displayed.
struct RaceInfoView: View {
    let race: Race

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(race.meetingName)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Text("Race \(race.raceNumber)")
                .font(.subheadline)
            if let category = RaceCategory(rawValue: race.categoryId) {
                Text("\(category.emoji) \(category.displayName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#if DEBUG
// MARK: - Previews

#Preview {
    // Create a sample Race for preview purposes.
    let sampleRace: Race = Race(
        id: "sampleRace",
        meetingName: "Sample Meeting",
        raceNumber: 3,
        advertisedStart: Date().addingTimeInterval(120),
        categoryId: RaceCategory.horse.rawValue
    )
    RaceInfoView(race: sampleRace)
}
#endif
