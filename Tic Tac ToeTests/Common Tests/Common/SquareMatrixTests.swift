//
//  SquareMatrixTests.swift
//  Tic Tac ToeTests
//
//  Created by Chris Feher on 2020-03-30.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import XCTest
@testable import Tic_Tac_Toe

class SquareMatrixTests: XCTestCase {

    // MARK: - init

    func test_init_returnsNilIfNotSquare() {
        // Arrange
        let data = [1, 2, 3]

        // Act
        let result = SquareMatrix(data: data)

        // Assert
        XCTAssertNil(result)
    }

    func test_init_returnsValueIfSquare() {
        // Arrange
        let data = [1, 2, 3, 4]

        // Act
        let result = SquareMatrix(data: data)

        // Assert
        XCTAssertNotNil(result)
    }

    // MARK: - Rows

    func test_rows_returnsCorrectValue() {
        // Arrange
        let data = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        let expectedValue = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

        // Act
        let result = SquareMatrix(data: data)?.rows

        // Assert
        XCTAssertEqual(result, expectedValue)
    }

    // MARK: - Columns

    func test_columns_returnsCorrectValue() {
        // Arrange
        let data = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        let expectedValue = [[1, 4, 7], [2, 5, 8], [3, 6, 9]]

        // Act
        let result = SquareMatrix(data: data)?.columns

        // Assert
        XCTAssertEqual(result, expectedValue)
    }

    // MARK: - Diagonals

    func test_diagonals_returnsCorrectValue() {
        // Arrange
        let data = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        let expectedValue = [[1, 5, 9], [3, 5, 7]]

        // Act
        let result = SquareMatrix(data: data)?.diagonals

        // Assert
        XCTAssertEqual(result, expectedValue)
    }
}
