//
//  RaceRowView.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 10/02/2025.
//

import SwiftUI

/// This view displays a single row for a race, including race information and a countdown timer.
///
/// It shows the race details using `RaceInfoView` on the left and the countdown until the race starts on the right.
struct RaceRowView: View {
    let race: Race
    let currentDate: Date
    
    var body: some View {
        HStack {
            RaceInfoView(race: race)
            Spacer()
            Text(race.countdown(from: currentDate))
                .font(.system(.body, design: .monospaced))
                .accessibilityLabel(countdownAccessibilityLabel)
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(race.meetingName) Race \(race.raceNumber)")
        .accessibilityValue(countdownAccessibilityLabel)
    }
    
    private var countdownAccessibilityLabel: String {
        let countdown = race.countdown(from: currentDate)
        return "Starting in \(countdown)"
    }
}

#if DEBUG
// MARK: - Previews

#Preview {
    let dummyRace = Race(
        id: "dummy",
        meetingName: "Dummy Meeting",
        raceNumber: 1,
        advertisedStart: Date().addingTimeInterval(120),
        categoryId: RaceCategory.horse.rawValue
    )
    RaceRowView(race: dummyRace, currentDate: Date())
}
#endif
