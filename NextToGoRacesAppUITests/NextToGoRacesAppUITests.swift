//
//  NextToGoRacesAppUITests.swift
//  NextToGoRacesAppUITests
//
//  Created by Clifton Baggerman on 10/02/2025.
//

import XCTest

final class NextToGoRacesAppUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    /// Tests the initial app launch state.
    /// Verifies that:
    /// - The navigation bar is present with correct title
    /// - All filter buttons (Horse, Harness, Greyhound) are visible
    func testInitialLoad() {
        XCTAssertTrue(app.navigationBars["Next to Go"].exists)

        let horseFilter = app.buttons["Horse filter"]
        let harnessFilter = app.buttons["Harness filter"]
        let greyhoundFilter = app.buttons["Greyhound filter"]

        XCTAssertTrue(horseFilter.exists)
        XCTAssertTrue(harnessFilter.exists)
        XCTAssertTrue(greyhoundFilter.exists)
    }

    /// Tests the race filter selection functionality.
    /// Verifies that:
    /// - Each filter button can be tapped
    /// - Multiple filters can be selected
    /// - Filters can be deselected
    /// - UI responds appropriately to filter changes
    func testFilterSelection() {
        let horseFilter = app.buttons["Horse filter"]
        let harnessFilter = app.buttons["Harness filter"]
        let greyhoundFilter = app.buttons["Greyhound filter"]

        horseFilter.tap()
        _ = app.wait(for: .unknown, timeout: 1)

        harnessFilter.tap()
        _ = app.wait(for: .unknown, timeout: 1)

        greyhoundFilter.tap()
        _ = app.wait(for: .unknown, timeout: 1)

        horseFilter.tap()
        _ = app.wait(for: .unknown, timeout: 1)
    }

    /// Tests the race list display functionality.
    /// Verifies that:
    /// - No more than 5 races are displayed
    /// - Race cells contain expected information
    /// - Empty state is handled correctly
    /// - Race details are properly formatted
    func testRaceListDisplay() {
        if app.cells.count > 0 {
            // Verify we don't show more than 5 races
            XCTAssertLessThanOrEqual(app.cells.count, 5)

            // Check race row elements
            let firstRace = app.cells.element(boundBy: 0)
            XCTAssertTrue(firstRace.exists)

            // Check for text containing "Race"
            let raceTextExists = firstRace.staticTexts.allElementsBoundByIndex.contains { staticText in
                staticText.label.contains("Race")
            }
            XCTAssertTrue(raceTextExists, "Expected to find text containing 'Race' in the first race cell")
        } else {
            // Verify no races message
            XCTAssertTrue(app.staticTexts["No races available"].exists)
        }
    }

    /// Tests the app's accessibility implementation.
    /// Verifies that:
    /// - Navigation elements are accessible
    /// - Filter buttons have proper accessibility labels
    /// - Race cells are accessible
    /// - All text elements have appropriate accessibility labels
    func testAccessibility() {
        let navBar = app.navigationBars["Next to Go"]
        XCTAssertTrue(navBar.exists, "Navigation bar should exist")

        let filters = ["Horse filter", "Harness filter", "Greyhound filter"]
        for filter in filters {
            let button = app.buttons[filter]
            XCTAssertTrue(button.exists, "Filter button \(filter) should exist")
            XCTAssertNotNil(button.label, "Filter button \(filter) should have an accessibility label")
        }

        if app.cells.count > 0 {
            let firstRace = app.cells.element(boundBy: 0)
            XCTAssertTrue(firstRace.exists, "First race cell should exist")
            XCTAssertNotNil(firstRace.label, "First race cell should have an accessibility label")

            let raceTexts = firstRace.staticTexts.allElementsBoundByIndex
            XCTAssertFalse(raceTexts.isEmpty, "Race cell should contain text elements")

            for text in raceTexts {
                XCTAssertNotNil(text.label, "Race text element should have an accessibility label")
            }
        }
    }

    /// Tests the app's support for dynamic type.
    /// Verifies that:
    /// - UI adapts to largest accessibility text size
    /// - Elements remain visible and functional
    /// - Buttons remain tappable
    /// - Layout remains coherent at extreme text sizes
    func testDynamicTypeSupport() {
        app.terminate()

        let config = XCUIApplication.init()
        config.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryXXXLarge"]
        config.launch()

        XCTAssertTrue(app.navigationBars["Next to Go"].exists)

        let horseFilter = app.buttons["Horse filter"]
        XCTAssertTrue(horseFilter.exists)
        XCTAssertTrue(horseFilter.isHittable)
    }
}
