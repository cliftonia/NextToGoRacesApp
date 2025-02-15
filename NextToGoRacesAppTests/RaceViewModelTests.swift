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

    @Test
    func testInitialState() {
        // Given
        let viewModel = RaceViewModel(raceService: MockRaceService(races: []))

        // Then
        #expect(viewModel.state == .loading)
    }

    @Test
    func testLoadingToLoadedTransition() async {
        // Given
        let mockRaces = [
            Race(id: "1",
                 meetingName: "Test Meeting",
                 raceNumber: 1,
                 advertisedStart: Date().addingTimeInterval(120),
                 categoryId: RaceCategory.horse.rawValue)
        ]
        let viewModel = RaceViewModel(raceService: MockRaceService(races: mockRaces))

        // When
        await viewModel.fetchRaces()

        // Then
        guard case .loaded(let races) = viewModel.state else {
            #expect(true == false, "Expected loaded state but got \(viewModel.state)")
            return
        }

        #expect(races.count == 1, "Expected one race but got \(races.count)")
        #expect(races[0].id == "1", "Expected race ID to be 1 but got \(races[0].id)")
    }

    @Test
    func testLoadingToEmptyTransition() async {
        // Given
        let viewModel = RaceViewModel(raceService: MockRaceService(races: []))

        // When
        await viewModel.fetchRacesForTesting()

        // Then
        #expect(viewModel.state == .empty)
    }

    @Test
    func testLoadingToErrorTransition() async {
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

    @Test
    func testRaceFiltering() async {
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

    @Test
    func testDisplayedRacesPlaceholderCount() {
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
