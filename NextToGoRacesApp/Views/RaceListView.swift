//
//  RaceListView.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 10/02/2025.
//

import SwiftUI

/// A view that displays a list of races for the "Next to Go" feature.
///
/// This view:
/// - Shows a `FilterView` at the top to filter races by category.
/// - Displays a `ProgressView` while races are loading.
/// - Presents an `ErrorView` if race data fails to load.
/// - Shows a `NoRacesView` if no races are available.
/// - Displays a list of `RaceRowView` items for each race, with placeholders where necessary.
///
/// The view is powered by `RaceViewModel`, which fetches and manages race data.
struct RaceListView: View {
    @StateObject private var viewModel: RaceViewModel

    init(viewModel: RaceViewModel = RaceViewModel(raceService: RaceService())) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                FilterView(selectedFilters: $viewModel.selectedCategories)

                switch viewModel.state {
                case .loading:
                    Spacer()
                    ProgressView("Loading races...")
                        .progressViewStyle(.circular)
                    Spacer()
                case .error(let error):
                    ErrorView(error: error)
                    Spacer()
                case .empty:
                    Spacer()
                    NoRacesView()
                    Spacer()
                case .loaded:
                    if viewModel.filteredRaces.isEmpty {
                        NoRacesView()
                        Spacer()
                    } else {
                        List(viewModel.displayedRaces) { displayableRace in
                            if let race = displayableRace.race {
                                RaceRowView(race: race, currentDate: viewModel.currentDate)
                            } else {
                                PlaceholderRaceRowView()
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle("Next to Go")
        }
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.stop() }
    }
}

#if DEBUG
// MARK: - Previews

#Preview("Loading State") {
    /// Displays `RaceListView` when the races are still loading.
    let mockService = MockRaceService(races: [], delay: 3)
    let vm = RaceViewModel(raceService: mockService)
    vm.state = .loading
    return RaceListView(viewModel: vm)
}

#Preview("No Races") {
    /// Displays `RaceListView` when no races are available.
    let mockService = MockRaceService(races: [])
    let vm = RaceViewModel(raceService: mockService)
    return RaceListView(viewModel: vm)
}

#Preview("With Sample Races") {
    /// Displays `RaceListView` populated with sample race data.
    let sampleHorse = Race(
        id: "horse1",
        meetingName: "Horse Meeting",
        raceNumber: 1,
        advertisedStart: Date().addingTimeInterval(120),
        categoryId: RaceCategory.horse.rawValue
    )

    let sampleGreyhound = Race(
        id: "greyhound1",
        meetingName: "Greyhound Meeting",
        raceNumber: 2,
        advertisedStart: Date().addingTimeInterval(180),
        categoryId: RaceCategory.greyhound.rawValue
    )

    let sampleHarness = Race(
        id: "harness1",
        meetingName: "Harness Meeting",
        raceNumber: 4,
        advertisedStart: Date().addingTimeInterval(180),
        categoryId: RaceCategory.harness.rawValue
    )

    // Mix five races from different categories.
    let sampleRaces: [Race] = [
        sampleHorse,
        sampleGreyhound,
        sampleHorse,
        sampleGreyhound,
        sampleHarness
    ]

    let mockService = MockRaceService(races: sampleRaces)
    let vm = RaceViewModel(raceService: mockService)
    return RaceListView(viewModel: vm)
}
#endif
