//
//  RaceServiceError.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 15/02/2025.
//

import Foundation

/// Represents errors that can occur when fetching or decoding race data from the Next to Go races API.
///
/// - Cases:
///   - invalidURL: The API endpoint URL is malformed or invalid.
///   - invalidResponse: The response from the server is not a valid HTTP response.
///   - httpError(statusCode: Int): The server responded with an HTTP error (non-200 status code).
///   - decodingError(Error): The response could not be decoded into the expected data model due to a decoding failure.
enum RaceServiceError: LocalizedError, Sendable, Equatable {  // Added Equatable
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    
    static func == (lhs: RaceServiceError, rhs: RaceServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case let (.httpError(lhsCode), .httpError(rhsCode)):
            return lhsCode == rhsCode
        case let (.decodingError(lhsError), .decodingError(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
