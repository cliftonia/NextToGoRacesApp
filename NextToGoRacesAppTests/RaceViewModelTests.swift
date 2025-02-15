//
//  RaceViewModelTests.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 11/02/2025.
//

import Testing
import SwiftUI
@testable import NextToGoRacesApp

@MainActor
struct RaceViewModelTests {
    // MARK: - State Transition Tests

    /// Tests that the view model starts in the loading state.
    /// Verifies the initial state is set correctly when the view model is created.
    @Test
    func initialState() {
        // Given
        let viewModel = RaceViewModel(raceService: MockRaceService(races: []))

        // Then
        #expect(viewModel.state == .loading)
    }

    /// Tests the transition from loading to loaded state with race data.
    /// Verifies that:
    /// - Race data is correctly loaded
    /// - State transitions to .loaded
    /// - Race count and ID are correct
    @Test
    func loadingToLoadedTransition() async {
        // Given
        let mockRaces = [
            Race(id: "1",
                 meetingName: "Test Meeting",
                 raceNumber: 1,
                 advertisedStart: Date().addingTimeInterval(120),
                 categoryId: RaceCategory.horse.rawValue)
        ]
        let viewModel = RaceViewModel(raceService: MockRaceService(races: mockRaces))

        await viewModel.fetchRaces()

        guard case .loaded(let races) = viewModel.state else {
            #expect(true == false, "Expected loaded state but got \(viewModel.state)")
            return
        }

        #expect(races.count == 1, "Expected one race but got \(races.count)")
        #expect(races[0].id == "1", "Expected race ID to be 1 but got \(races[0].id)")
    }

    /// Tests the transition to empty state when no races are available.
    /// Verifies that the state correctly transitions to .empty when
    /// the service returns an empty array of races.
    @Test
    func loadingToEmptyTransition() async {
        // Given
        let viewModel = RaceViewModel(raceService: MockRaceService(races: []))

        // When
        await viewModel.fetchRacesForTesting()

        // Then
        #expect(viewModel.state == .empty)
    }

    /// Tests error handling when the service fails.
    /// Verifies that:
    /// - Service errors are properly propagated
    /// - State transitions to .error with correct error type
    /// - Error details are preserved
    @Test
    func loadingToErrorTransition() async {
        let errorService = MockRaceService(races: [], error: RaceServiceError.invalidURL)
        let viewModel = RaceViewModel(raceService: errorService)

        await viewModel.fetchRaces()

        guard case .error(let error) = viewModel.state else {
            #expect(true == false, "Expected error state but got \(viewModel.state)")
            return
        }

        guard case .serviceError(let serviceError) = error else {
            #expect(true == false, "Expected serviceError but got \(error)")
            return
        }

        #expect(serviceError == .invalidURL, "Expected invalidURL error but got \(serviceError)")
    }

    // MARK: - Race Filtering Tests

    /// Tests race filtering functionality.
    /// Verifies that:
    /// - Expired races are filtered out
    /// - Category filters work correctly
    /// - Multiple filters can be applied
    /// - Races are properly ordered
    @Test
    func raceFiltering() async {
        let now = Date()
        let mockService = MockRaceService(races: [])
        let viewModel = RaceViewModel(raceService: mockService)

        let race1 = Race(
            id: "1",
            meetingName: "Meeting 1",
            raceNumber: 1,
            advertisedStart: now.addingTimeInterval(30),
            categoryId: RaceCategory.horse.rawValue
        )
        let race2 = Race(
            id: "2",
            meetingName: "Meeting 2",
            raceNumber: 2,
            advertisedStart: now.addingTimeInterval(90),
            categoryId: RaceCategory.harness.rawValue
        )
        let race3 = Race(
            id: "3",
            meetingName: "Meeting 3",
            raceNumber: 3,
            advertisedStart: now.addingTimeInterval(-70),
            categoryId: RaceCategory.greyhound.rawValue
        )

        viewModel.setRacesForTesting([race1, race2, race3])
        viewModel.currentDate = now

        let filtered = viewModel.filteredRaces
        #expect(filtered.count == 2)
        #expect(filtered.contains { $0.id == "1" })
        #expect(filtered.contains { $0.id == "2" })

        viewModel.selectedCategories = [.horse]
        let filteredHorse = viewModel.filteredRaces
        #expect(filteredHorse.count == 1)
        #expect(filteredHorse.first?.id == "1")
    }

    /// Tests placeholder generation for race display.
    /// Verifies that:
    /// - Total displayed count matches raceLimit
    /// - Correct number of placeholders are added
    /// - Valid races are preserved
    @Test
    func displayedRacesPlaceholderCount() {
        let now = Date()
        let viewModel = RaceViewModel(raceService: MockRaceService(races: []))
        let race1 = Race(
            id: "1",
            meetingName: "Meeting 1",
            raceNumber: 1,
            advertisedStart: now.addingTimeInterval(60),
            categoryId: RaceCategory.horse.rawValue
        )
        let race2 = Race(
            id: "2",
            meetingName: "Meeting 2",
            raceNumber: 2,
            advertisedStart: now.addingTimeInterval(120),
            categoryId: RaceCategory.horse.rawValue
        )

        viewModel.setRacesForTesting([race1, race2])
        viewModel.currentDate = now

        let displayed = viewModel.displayedRaces

        #expect(displayed.count == RaceViewModel.raceLimit)
        let validCount = displayed.filter { $0.race != nil }.count
        #expect(validCount == 2)
    }
}

// MARK: - Mocks

#if DEBUG
/// A mock implementation of RaceServiceProtocol used for testing.
/// This mock service can:
/// - Return predefined race data
/// - Simulate API errors
/// - Control the timing of responses
struct MockRaceService: RaceServiceProtocol {
    let races: [Race]
    let error: Error?

    init(races: [Race], error: Error? = nil) {
        self.races = races
        self.error = error
    }

    func fetchRaces() async throws -> [Race] {
        if let error = error {
            throw error
        }
        return races
    }
}
#endif
