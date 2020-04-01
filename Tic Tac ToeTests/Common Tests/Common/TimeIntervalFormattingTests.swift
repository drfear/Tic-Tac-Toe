//
//  TimeIntervalFormattingTests.swift
//  Tic Tac ToeTests
//
//  Created by Chris Feher on 2020-03-30.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import XCTest
@testable import Tic_Tac_Toe

class TimeIntervalFormattingTests: XCTestCase {

    func test_format_secondsOnly_returnsCorrectValue() {
        // Arrange
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(25)
        let timeInterval = endDate.timeIntervalSince(startDate)

        let expectedValue = "25 sec"

        // Act
        let result = timeInterval.format()

        // Assert
        XCTAssertEqual(result, expectedValue)
    }

    func test_format_secondsAndMinutes_returnsCorrectValue() {
        // Arrange
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(85)
        let timeInterval = endDate.timeIntervalSince(startDate)

        let expectedValue = "1 min, 25 sec"

        // Act
        let result = timeInterval.format()

        // Assert
        XCTAssertEqual(result, expectedValue)
    }

    func test_format_secondMinutesHours_returnsCorrectValue() {
        // Arrange
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(3685)
        let timeInterval = endDate.timeIntervalSince(startDate)

        let expectedValue = "61 min, 25 sec"

        // Act
        let result = timeInterval.format()

        // Assert
        XCTAssertEqual(result, expectedValue)
    }
}
