//
//  RaceServiceTests.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 11/02/2025.
//

import Testing
import Foundation
@testable import NextToGoRacesApp

struct RaceServiceTests {
    @Test
    func testRaceResponseDecoding() throws {
        let jsonString = """
        {
          "status": 200,
          "data": {
            "next_to_go_ids": ["1", "2"],
            "race_summaries": {
              "1": {
                "race_id": "1",
                "meeting_name": "Test Meeting",
                "race_number": 1,
                "advertised_start": {"seconds": 1739254740},
                "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae"
              },
              "2": {
                "race_id": "2",
                "meeting_name": "Another Meeting",
                "race_number": 2,
                "advertised_start": {"seconds": 1739254800},
                "category_id": "161d9be2-e909-4326-8c2c-35ed71fb460b"
              }
            }
          }
        }
        """
        let data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let raceResponse = try decoder.decode(RaceResponse.self, from: data)
        #expect(raceResponse.data.raceSummaries.count == 2)
        #expect(raceResponse.data.raceSummaries["1"]?.meetingName == "Test Meeting")
    }

    @Test
    func testRaceOrdering() throws {
        let jsonString = """
        {
          "status": 200,
          "data": {
            "next_to_go_ids": ["2", "1"],
            "race_summaries": {
              "1": {
                "race_id": "1",
                "meeting_name": "Test Meeting 1",
                "race_number": 1,
                "advertised_start": {"seconds": 1739254740},
                "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae"
              },
              "2": {
                "race_id": "2",
                "meeting_name": "Test Meeting 2",
                "race_number": 2,
                "advertised_start": {"seconds": 1739254800},
                "category_id": "161d9be2-e909-4326-8c2c-35ed71fb460b"
              }
            }
          }
        }
        """
        let data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let raceResponse = try decoder.decode(RaceResponse.self, from: data)
        // Simulate ordering: the first race should be "2" and the second "1".
        let orderedRaces = raceResponse.data.nextToGoIds.compactMap { raceResponse.data.raceSummaries[$0] }
        #expect(orderedRaces.first?.id == "2")
        #expect(orderedRaces.last?.id == "1")
    }
}
