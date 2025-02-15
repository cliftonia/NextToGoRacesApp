//
//  RaceViewModelError.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 15/02/2025.
//

import Foundation

/// Represents errors encountered in the RaceViewModel.
///
/// - Cases:
///   - serviceError: Wraps an underlying `RaceServiceError` encountered during a network fetch.
///   - unknown: Wraps any other unexpected error.
enum RaceViewModelError: LocalizedError {
    case serviceError(RaceServiceError)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .serviceError(let error):
            return error.localizedDescription
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
