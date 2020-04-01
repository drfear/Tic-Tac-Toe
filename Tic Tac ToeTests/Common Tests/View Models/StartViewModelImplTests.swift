//
//  StartViewModelImplTests.swift
//  Tic Tac ToeTests
//
//  Created by Chris Feher on 2020-03-31.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import XCTest
@testable import Tic_Tac_Toe

// MARK: - MemoryPersistentStorageImpl

class MemoryPersistentStorageImpl: PersistentStorage {

    private var storage = [String: Data]()

    func set(_ data: Data?, forKey key: String) {
        storage[key] = data
    }

    func getData(forKey key: String) -> Data? {
        return storage[key]
    }
}

// MARK: - StartViewModelImplTests

class StartViewModelImplTests: XCTestCase {

    var sut: StartViewModelImpl!
    var gameDataProvider: GameDataProvider!

    override func setUp() {
        gameDataProvider = GameDataProviderImpl(storage: MemoryPersistentStorageImpl())
        sut = StartViewModelImpl(gameDataReading: gameDataProvider)
    }

    // MARK: - lastWinnerName

    func test_lastWinnerName_returnsExpectedValue() {
        // Arrage
        let gameData = GameData(startTime: Date(), endTime: Date(), winnerName: "name_1", numberOfTurns: 0)
        gameDataProvider.writeLastGameData(gameData)

        // Act
        sut.updateGameData()
        let result = sut.lastWinnerName

        // Assert
        XCTAssertEqual("name_1", result)
    }

    func test_lastWinnerName_noSave_returnsNil() {
        // Arrage

        // Act
        let result = sut.lastWinnerName

        // Assert
        XCTAssertEqual(nil, result)
    }

    // MARK: - lastGameNumberOfTurns

    func test_lastGameNumberOfTurns_returnsExpectedValue() {
        // Arrage
        let gameData = GameData(startTime: Date(), endTime: Date(), winnerName: "name_1", numberOfTurns: 7)
        gameDataProvider.writeLastGameData(gameData)

        // Act
        sut.updateGameData()
        let result = sut.lastGameNumberOfTurns

        // Assert
        XCTAssertEqual(7, result)
    }

    func test_lastGameNumberOfTurns_noSave_returnsNil() {
        // Arrage

        // Act
        let result = sut.lastGameNumberOfTurns

        // Assert
        XCTAssertEqual(nil, result)
    }

    // MARK: - formattedLastGameTime

    func test_formattedLastGameTimes_returnsExpectedValue() {
        // Arrage
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(363)
        let gameData = GameData(startTime: startDate, endTime: endDate, winnerName: "name_1", numberOfTurns: 7)
        gameDataProvider.writeLastGameData(gameData)

        // Act
        sut.updateGameData()
        let result = sut.formattedLastGameTime

        // Assert
        XCTAssertEqual("6 min, 3 sec", result)
    }

    func test_formattedLastGameTime_noSave_returnsNil() {
        // Arrage

        // Act
        let result = sut.formattedLastGameTime

        // Assert
        XCTAssertEqual(nil, result)
    }

    // MARK: - gameDataUpdated

    func test_gameDataUpdated_calledAfterUpdate() {
        // Arrage
        let exp = expectation(description: "gameDataUpdated")
        sut.gameDataUpdated = {
            exp.fulfill()
        }

        // Act
        sut.updateGameData()

        // Assert
        waitForExpectations(timeout: 1)
    }
}
