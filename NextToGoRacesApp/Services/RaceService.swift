//
//  RaceService.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 11/02/2025.
//

import Foundation

/// A protocol defining the interface for fetching races from the Next to Go races API.
///
/// Conforming types must implement an asynchronous method to retrieve an array of `Race` objects.
protocol RaceServiceProtocol: Sendable {
    /// Fetches an array of upcoming races asynchronously.
    ///
    /// - Returns: An array of `Race` objects ordered as specified by the API.
    /// - Throws: A `RaceServiceError` if the network call fails or if the response cannot be decoded.
    func fetchRaces() async throws -> [Race]
}

/// An actor-based implementation of `RaceServiceProtocol`, ensuring thread safety when fetching races.
///
/// - Properties:
///   - urlSession: The `URLSession` instance used for making network requests.
///   - endpoint: The API endpoint URL string for retrieving the next races.
actor RaceService: RaceServiceProtocol {
    private let urlSession: URLSession
    private let endpoint = "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10"

    /// Initializes a new instance of `RaceService`.
    ///
    /// - Parameter urlSession: The `URLSession` instance used for network calls. Defaults to `URLSession.shared`.
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    /// Fetches the next races from the Next to Go races API.
    ///
    /// This method:
    /// 1. Sends an asynchronous network request to the API endpoint.
    /// 2. Validates the HTTP response.
    /// 3. Decodes the JSON response into a `RaceResponse` model.
    /// 4. Extracts and orders the races based on `next_to_go_ids`.
    ///
    /// - Returns: An array of `Race` objects, ordered according to the API's response.
    /// - Throws: A `RaceServiceError` if:
    ///   - The endpoint URL is invalid.
    ///   - The response is not a valid HTTP response.
    ///   - The HTTP status code is not 200.
    ///   - Decoding the JSON response fails.
    func fetchRaces() async throws -> [Race] {
        guard let url = URL(string: endpoint) else {
            throw RaceServiceError.invalidURL
        }

        let (data, response): (Data, URLResponse) = try await urlSession.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw RaceServiceError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw RaceServiceError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoder: JSONDecoder = JSONDecoder()
        let raceResponse: RaceResponse = try decoder.decode(RaceResponse.self, from: data)

        /// Extracts and orders races according to `next_to_go_ids`.
        /// Uses `compactMap` to filter out any IDs that do not have corresponding race data.
        let orderedRaces: [Race] = raceResponse.data.nextToGoIds.compactMap { id in
            raceResponse.data.raceSummaries[id]
        }
        return orderedRaces
    }
}

#if DEBUG
/// A mock implementation of `RaceServiceProtocol` for UI previews.
///
/// This mock service can return a predefined list of races or simulate an error.
struct MockRaceService: RaceServiceProtocol {
    let races: [Race]
    let error: Error?
    let delay: TimeInterval

    /// Initializes a mock race service.
    ///
    /// - Parameters:
    ///   - races: A predefined list of races to return.
    ///   - error: An optional error to simulate a failed API response.
    ///   - delay: The artificial delay (in seconds) before returning data.
    init(races: [Race] = [], error: Error? = nil, delay: TimeInterval = 0) {
        self.races = races
        self.error = error
        self.delay = delay
    }

    /// Fetches races asynchronously with an optional delay.
    ///
    /// - Returns: A predefined list of races or throws an error if one is set.
    func fetchRaces() async throws -> [Race] {
        if delay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        if let error: Error = error {
            throw error
        }
        return races
    }
}
#endif
