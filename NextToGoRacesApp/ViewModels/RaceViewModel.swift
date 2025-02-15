//
//  RaceViewModel.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 10/02/2025.
//

import SwiftUI

/// The view model responsible for managing race data for the Next to Go races UI.
///
/// - Properties:
///   - raceLimit: The maximum number of races to display (set to 5).
///   - refreshInterval: The time interval (in seconds) for refreshing race data.
///   - gracePeriod: The grace period (in seconds) to allow filtering out past races.
///   - state: The current loading state of race data.
///   - currentDate: The current date, updated every second for real-time countdowns.
///   - selectedCategories: The set of race categories selected for filtering.
///   - raceService: The service responsible for fetching race data.
@MainActor
final class RaceViewModel: ObservableObject {
    // MARK: - Constants

    static let raceLimit: Int = 5
    static let refreshInterval: TimeInterval = 10
    static let gracePeriod: TimeInterval = 60

    // MARK: - Published Properties

    @Published var state: RaceViewState = .loading
    @Published var currentDate: Date = Date()
    @Published var selectedCategories: Set<RaceCategory> = []

    // MARK: - Private Properties

    private var refreshTask: Task<Void, Never>?
    private var timer: Timer?
    private let raceService: RaceServiceProtocol

    // MARK: - Initialization

    /// Initializes the `RaceViewModel` with a race service.
    ///
    /// - Parameter raceService: The `RaceServiceProtocol` implementation used to fetch race data.
    init(raceService: RaceServiceProtocol) {
        self.raceService = raceService
    }

    // MARK: - Public Methods

    /// Starts the automatic update mechanisms:
    /// - A timer that updates the `currentDate` every second.
    /// - A background task that periodically fetches new race data.
    func start() {
        startTimer()
        startRefreshTask()
    }

    /// Stops all background tasks and timers.
    ///
    /// This method cancels the ongoing refresh task and invalidates the countdown timer.
    func stop() {
        refreshTask?.cancel()
        refreshTask = nil
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Private Methods

    /// Starts a timer that updates the `currentDate` every second.
    ///
    /// This allows real-time countdowns to be displayed accurately.
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.currentDate = Date()
            }
        }
    }

    /// Starts a background task that periodically fetches races at `refreshInterval` intervals.
    ///
    /// The task runs indefinitely until `stop()` is called.
    private func startRefreshTask() {
        refreshTask = Task { [weak self] in
            guard let self = self else { return }
            while !Task.isCancelled {
                await self.fetchRaces()
                try? await Task.sleep(nanoseconds: UInt64(Self.refreshInterval * 1_000_000_000))
            }
        }
    }

    /// Fetches the latest races from the API and updates the view state.
    ///
    /// - If successful:
    ///   - Updates `state` to `.loaded(races)` when races are available.
    ///   - Updates `state` to `.empty` when no races are returned.
    ///   - **Prevents unnecessary state changes if the race data hasn't changed** (fixes UI flickering).
    /// - If an error occurs:
    ///   - Updates `state` to `.error(serviceError)` for known API errors.
    ///   - Updates `state` to `.error(unknown)` for unexpected errors.
    func fetchRaces() async {
        do {
            let fetchedRaces = try await raceService.fetchRaces()

            if case .loaded(let existingRaces) = state, existingRaces == fetchedRaces {
                return
            }

            if fetchedRaces.isEmpty {
                state = .empty
            } else {
                state = .loaded(fetchedRaces)
            }
        } catch let error as RaceServiceError {
            state = .error(.serviceError(error))
        } catch {
            state = .error(.unknown(error))
        }
    }

    // MARK: - Public Computed Properties

    /// Filters races based on the current date and selected categories.
    ///
    /// - Excludes races that have already started beyond the `gracePeriod`.
    /// - Includes only races from selected categories (if any are selected).
    /// - Sorts races by `advertisedStart` in ascending order.
    /// - Limits the number of races displayed to `raceLimit`.
    var filteredRaces: [Race] {
        switch state {
        case .loaded(let races):
            return races.filter { race in
                currentDate <= race.advertisedStart.addingTimeInterval(Self.gracePeriod)
            }
            .filter { race in
                selectedCategories.isEmpty || selectedCategories.contains { $0.rawValue == race.categoryId }
            }
            .sorted { $0.advertisedStart < $1.advertisedStart }
            .prefix(Self.raceLimit)
            .map { $0 }
        default:
            return []
        }
    }

    /// Creates a list of `DisplayableRace` objects, including placeholders if needed.
    ///
    /// - Converts `filteredRaces` into `DisplayableRace` objects, maintaining stable IDs.
    /// - If the number of valid races is less than `raceLimit`, adds placeholders to fill the remaining slots.
    ///
    /// - Returns: An array of `DisplayableRace` objects ready for UI display.
    var displayedRaces: [DisplayableRace] {
        let validRaces = filteredRaces.enumerated().map { (index, race) in
            DisplayableRace(race: race, index: index)
        }
        let placeholdersNeeded = max(0, Self.raceLimit - validRaces.count)
        let placeholders = (0..<placeholdersNeeded).map { DisplayableRace.placeholder(index: $0) }
        return validRaces + placeholders
    }
}

#if DEBUG
extension RaceViewModel {
    /// Sets a predefined list of races for UI testing.
    ///
    /// - Note: This method is only available in debug builds.
    /// - Parameter races: The test race data to be injected.
    func setRacesForTesting(_ races: [Race]) {
        state = .loaded(races)
    }
}
#endif
