//
//  DisplayableRace.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 15/02/2025.
//

import Foundation

/// A stable wrapper for displaying a race in the UI.
///
/// This struct ensures that UI components can reliably track and display race updates,
/// even if race data changes dynamically.
///
/// - Properties:
///   - id: A unique identifier for display purposes, combining the race ID and an index.
///   - race: The optional `Race` object; if `nil`, this instance represents a placeholder.
struct DisplayableRace: Identifiable {
    let id: String
    let race: Race?
    
    /// Creates a `DisplayableRace` instance with a unique identifier.
    ///
    /// This ensures that each displayed race has a stable identifier by appending
    /// an index to the original race ID. This approach prevents UI rendering issues
    /// when race data updates frequently.
    ///
    /// - Parameters:
    ///   - race: The `Race` object to be wrapped.
    ///   - index: A unique index used to distinguish multiple races with the same ID.
    init(race: Race, index: Int) {
        self.race = race
        self.id = "\(race.id)-\(index)"
    }
    
    /// Creates a placeholder `DisplayableRace` with a unique identifier.
    ///
    /// Placeholder instances are used when actual race data is not yet available.
    /// This helps maintain a stable UI layout while data is being loaded.
    ///
    /// - Parameter index: A unique index to differentiate multiple placeholders.
    /// - Returns: A `DisplayableRace` instance representing a placeholder.
    static func placeholder(index: Int) -> DisplayableRace {
        DisplayableRace(id: "placeholder-\(index)", race: nil)
    }
    
    /// Private initializer used for creating a `DisplayableRace` instance with a custom ID.
    ///
    /// This is used internally by the `placeholder(index:)` factory method.
    private init(id: String, race: Race?) {
        self.id = id
        self.race = race
    }
}
