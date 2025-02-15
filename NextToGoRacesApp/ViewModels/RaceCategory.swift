//
//  RaceCategory.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 15/02/2025.
//

import Foundation

/// Represents the category of a race.
///
/// - Cases:
///   - greyhound: Category for Greyhound racing.
///   - harness: Category for Harness racing.
///   - horse: Category for Horse racing.
enum RaceCategory: String, CaseIterable {
    case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    case horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    
    /// A human-readable name for the race category.
    var displayName: String {
        switch self {
        case .greyhound: return "Greyhound"
        case .harness: return "Harness"
        case .horse: return "Horse"
        }
    }
    
    /// An emoji representing the race category.
    var emoji: String {
        switch self {
        case .greyhound:
            return "🐕"
        case .harness:
            return "🐎🛷"
        case .horse:
            return "🐎"
        }
    }
    
    /// An SF symbol representing the race category.
    var sfSymbol: String {
        switch self {
        case .horse:
            return "figure.equestrian.sports"
        case .harness:
            return "figure.equestrian.sports.circle"  // Could also use "figure.run" or "figure.outdoor.cycle"
        case .greyhound:
            return "dog"  // Could also use "dog" but "hare" better represents racing
        }
    }
}
