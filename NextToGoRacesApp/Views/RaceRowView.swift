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
        .accessibilityLabel(accessibilityRaceLabel)
        .accessibilityValue(countdownAccessibilityLabel)
        .accessibilityRemoveTraits(.isHeader)
    }
    
    /// A computed property that provides an accessibility-friendly race label.
    ///
    /// - Returns: A string describing the race category, meeting name, and race number.
    private var accessibilityRaceLabel: String {
        let categoryName: String = RaceCategory(rawValue: race.categoryId)?.displayName ?? "Race"
        return "\(categoryName) Race at \(race.meetingName), Race \(race.raceNumber)"
    }
    
    /// A computed property that provides an accessibility-friendly countdown label for the race.
    ///
    /// This function calculates the time remaining until the race starts and returns a properly formatted
    /// string, ensuring VoiceOver users receive clear and accurate information.
    ///
    /// - If the race has already started, it announces: `"Race has started"`
    /// - If the countdown is less than a minute, it announces only seconds: `"Time remaining until start: X seconds"`
    /// - If there are no seconds left, it announces only minutes: `"Time remaining until start: X minutes"`
    /// - If both minutes and seconds exist, it announces both: `"Time remaining until start: X minutes and Y seconds"`
    private var countdownAccessibilityLabel: String {
        let components: DateComponents = Calendar.current.dateComponents([.minute, .second], from: currentDate, to: race.advertisedStart)
        let minutes: Int = components.minute ?? 0
        let seconds: Int = components.second ?? 0
        
        if minutes < 0 || seconds < 0 {
            return "Race has started"
        }
        
        if minutes == 0 && seconds > 0 {
            return "Time remaining until start: \(seconds) second\(seconds == 1 ? "" : "s")"
        } else if seconds == 0 {
            return "Time remaining until start: \(minutes) minute\(minutes == 1 ? "" : "s")"
        } else {
            return "Time remaining until start: \(minutes) minute\(minutes == 1 ? "" : "s") and \(seconds) second\(seconds == 1 ? "" : "s")"
        }
    }
}

#if DEBUG
// MARK: - Previews

#Preview {
    let dummyRace: Race = Race(
        id: "dummy",
        meetingName: "Dummy Meeting",
        raceNumber: 1,
        advertisedStart: Date().addingTimeInterval(120),
        categoryId: RaceCategory.horse.rawValue
    )
    RaceRowView(race: dummyRace, currentDate: Date())
}
#endif
