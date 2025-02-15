//
//  RaceTests.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 15/02/2025.
//

import Testing
import SwiftUI
@testable import NextToGoRacesApp

struct RaceTests {
    /// Tests countdown formatting for a future race.
    /// Verifies that:
    /// - A race starting in 2 minutes shows "02:00"
    /// - Minutes and seconds are properly formatted with leading zeros
    @Test
    func raceCountdown() {
        // Given: a race starting 2 minutes from now.
        let now: Date = Date()
        let startDate: Date = now.addingTimeInterval(120)
        let race = Race(
            id: "1",
            meetingName: "Test Meeting",
            raceNumber: 1,
            advertisedStart: startDate,
            categoryId: RaceCategory.horse.rawValue
        )

        let countdown = race.countdown(from: now)

        #expect(countdown == "02:00")
    }

    /// Tests countdown display for a race that has already started.
    /// Verifies that:
    /// - A race that started in the past shows "Started"
    /// - Negative time intervals are handled correctly
    @Test
    func raceAlreadyStartedCountdown() {
        let now: Date = Date()
        let startDate: Date = now.addingTimeInterval(-10)
        let race = Race(
            id: "1",
            meetingName: "Started Race",
            raceNumber: 1,
            advertisedStart: startDate,
            categoryId: RaceCategory.horse.rawValue
        )

        let countdown = race.countdown(from: now)

        #expect(countdown == "Started")
    }
}

#if DEBUG
extension RaceViewModel {
    /// Test-only method to fetch races.
    /// This allows tests to directly trigger race fetching without waiting for the refresh cycle.
    func fetchRacesForTesting() async {
        await fetchRaces()
    }

    /// Test-only method to set race data directly.
    /// - Parameter races: An array of Race objects to set as the current state.
    func setRacesForTesting(_ races: [Race]) {
        state = .loaded(races)
    }

    /// Test-only method to set a specific state.
    /// Useful for testing different state transitions and UI responses.
    /// - Parameter newState: The RaceViewState to set.
    func setState(_ newState: RaceViewState) {
        state = newState
    }

    /// Test-only method to simulate error states.
    /// - Parameter error: The error to set in the state.
    func setErrorForTesting(_ error: RaceViewModelError) {
        state = .error(error)
    }
}
#endif
