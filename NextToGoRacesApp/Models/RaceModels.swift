//
//  RaceModels.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 15/02/2025.
//

import Foundation

/// The top-level response model for the Next to Go races API.
///
/// - Properties:
///   - status: The HTTP status code returned by the API.
///   - data: An instance of `RaceData` that contains the core race information.
struct RaceResponse: Decodable, Sendable {
    let status: Int
    let data: RaceData
}

/// Holds the core race information, including the IDs of the next races to go
/// and a dictionary of race summaries keyed by their IDs.
///
/// - Properties:
///   - nextToGoIds: An array of race IDs in the order they should be displayed.
///   - raceSummaries: A dictionary mapping each race ID to its corresponding `Race` object.
struct RaceData: Decodable, Sendable {
    let nextToGoIds: [String]
    let raceSummaries: [String: Race]

    enum CodingKeys: String, CodingKey {
        case nextToGoIds = "next_to_go_ids"
        case raceSummaries = "race_summaries"
    }
}

/// A struct representing the advertised start time of a race.
///
/// - Properties:
///   - seconds: The start time in epoch seconds.
struct AdvertisedStart: Decodable, Sendable {
    let seconds: Int64
}

/// Represents a single race in the Next to Go API.
///
/// - Properties:
///   - id: The unique identifier of the race.
///   - meetingName: The name of the meeting or venue where the race takes place.
///   - raceNumber: The race number at the meeting.
///   - advertisedStart: The advertised start time as a `Date` (converted from epoch seconds).
///   - categoryId: The category identifier (e.g., horse, harness, greyhound).
struct Race: Identifiable, Decodable, Sendable {
    let id: String
    let meetingName: String
    let raceNumber: Int
    let advertisedStart: Date
    let categoryId: String

    enum CodingKeys: String, CodingKey {
        case id = "race_id"
        case meetingName = "meeting_name"
        case raceNumber = "race_number"
        case advertisedStart = "advertised_start"
        case categoryId = "category_id"
    }

    /// Custom initializer to decode a `Race` instance from JSON.
    ///
    /// - Parameter decoder: The `Decoder` used to parse JSON data.
    /// - Throws: A `DecodingError` if required keys are missing or if decoding fails.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        meetingName = try container.decode(String.self, forKey: .meetingName)
        raceNumber = try container.decode(Int.self, forKey: .raceNumber)
        categoryId = try container.decode(String.self, forKey: .categoryId)

        let startContainer = try container.decode(AdvertisedStart.self, forKey: .advertisedStart)
        advertisedStart = Date(timeIntervalSince1970: Double(startContainer.seconds))
    }

    /// Convenience initializer for creating test instances of `Race`.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the race.
    ///   - meetingName: The name of the meeting or venue.
    ///   - raceNumber: The race number within that meeting.
    ///   - advertisedStart: A `Date` representing when the race starts.
    ///   - categoryId: The category ID string (e.g., horse, harness, greyhound).
    init(id: String, meetingName: String, raceNumber: Int, advertisedStart: Date, categoryId: String) {
        self.id = id
        self.meetingName = meetingName
        self.raceNumber = raceNumber
        self.advertisedStart = advertisedStart
        self.categoryId = categoryId
    }

    /// Returns a countdown string (in `MM:SS` format) showing how much time remains
    /// until the race starts, relative to the given `currentDate`.
    ///
    /// - Parameter currentDate: The current `Date` to calculate the countdown from.
    /// - Returns: A string in `MM:SS` format if the race has not yet started,
    ///   or `"Started"` if the race is already underway.
    func countdown(from currentDate: Date) -> String {
        let interval = Int(advertisedStart.timeIntervalSince(currentDate))
        guard interval > 0 else { return "Started" }
        let minutes = interval / 60
        let seconds = interval % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

/// Conforms `Race` to `Equatable` for comparison.
///
/// This implementation considers two `Race` instances equal if they have the same `id`,
/// since race IDs are unique identifiers.
extension Race: Equatable {
    static func == (lhs: Race, rhs: Race) -> Bool {
        return lhs.id == rhs.id
    }
}
