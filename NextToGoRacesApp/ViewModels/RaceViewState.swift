//
//  RaceViewState.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 15/02/2025.
//

import Foundation

/// Represents the different possible states of the race view.
///
/// This enum is used to manage UI updates based on race data fetching results.
enum RaceViewState: Equatable {
    case loading
    case loaded([Race])
    case error(RaceViewModelError)
    case empty
    
    static func == (lhs: RaceViewState, rhs: RaceViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.empty, .empty):
            return true
        case let (.loaded(lhsRaces), .loaded(rhsRaces)):
            return lhsRaces == rhsRaces
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
