//
//  StartViewModelImplTests.swift
//  Tic Tac ToeTests
//
//  Created by Chris Feher on 2020-03-31.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import XCTest
@testable import Tic_Tac_Toe

// MARK: - TestDateProviderImpl

class TestDateProviderImpl: DateProvider {

    var offset: TimeInterval = 0

    var date: Date {
        return Date(timeIntervalSince1970: 1585661).addingTimeInterval(offset)
    }
}

// MARK: - TestGameDataWriting

class TestGameDataWritingImpl: GameDataWriting {

    var writeLastGameDataCallback: ((GameData) -> ())?

    func writeLastGameData(_ gameData: GameData) {
        writeLastGameDataCallback?(gameData)
    }
}

// MARK: - GameViewModelImplTests

class GameViewModelImplTests: XCTestCase {

    var sut: GameViewModelImpl!
    var gameDataWriting: TestGameDataWritingImpl!
    var dateProvider: TestDateProviderImpl!

    override func setUp() {
        dateProvider = TestDateProviderImpl()
        gameDataWriting = TestGameDataWritingImpl()
        sut = GameViewModelImpl(gameDataWriting: gameDataWriting, dateProvider: dateProvider)
    }

    // MARK: - selections

    func test_selections_countReturns9() {
        // Arrage
        let expectedValue = 9

        // Act
        let result = sut.selections.count

        // Assert
        XCTAssertEqual(result, expectedValue)
    }

    func test_selections_initialValue_returnsExpectedValue() {
        // Arrage
        let expectedValue = (0..<9).map { _ in TicTacToeSquareViewModelImpl(piece: .empty) }.map { $0.piece }

        // Act
        let result = sut.selections.map { $0.piece }

        // Assert
        XCTAssertEqual(result, expectedValue)
    }

    func test_selections_selectSquares_arrangedCorrectly() {
        // Arrage
        let expectedValue = (0..<9).map { index in
            let piece = index == 3 ? Piece.x : .empty
            return TicTacToeSquareViewModelImpl(piece: piece)
        }.map { (model: TicTacToeSquareViewModelImpl) in model.piece }

        _ = sut.player(.player1, selected: 3)

        // Act
        let result = sut.selections.map { $0.piece }

        // Assert
        XCTAssertEqual(result, expectedValue)
    }

    func test_selections_doubleSelection_doesNotUpdateSelections() {
        // Arrage
        let expectedValue = (0..<9).map { index in
            let piece = index == 3 ? Piece.x : .empty
            return TicTacToeSquareViewModelImpl(piece: piece)
        }.map { (model: TicTacToeSquareViewModelImpl) in model.piece }


        // Act
        _ = sut.player(.player1, selected: 3)
        _ = sut.player(.player2, selected: 3)
        let result = sut.selections.map { $0.piece }

        // Assert
        XCTAssertEqual(result, expectedValue)
    }

    // MARK: - playerSelectedIndex

    func test_playerSelectedIndex_squareEmpty_returnsTrue() {
        // Arrage
        let expectedValue = true

        // Act
        let result = sut.player(.player1, selected: 3)

        // Assert
        XCTAssertEqual(result, expectedValue)
    }

    func test_playerSelectedIndex_squareTaken_returnsFalse() {
        // Arrage
        let expectedValue = false

        // Act
        _ = sut.player(.player1, selected: 3)
        let result = sut.player(.player2, selected: 3)

        // Assert
        XCTAssertEqual(result, expectedValue)
    }

    // MARK: - gameOver

    func test_gameOver_player1WinsRow_gameOverCalledWithPlayer1() {
        // Arrage
        let expectedWinner = Player.player1

        sut.gameOver = { player in
            XCTAssertEqual(player, expectedWinner)
        }

        // Act
        _ = sut.player(.player1, selected: 0)
        _ = sut.player(.player2, selected: 4)
        _ = sut.player(.player1, selected: 1)
        _ = sut.player(.player2, selected: 5)
        _ = sut.player(.player1, selected: 2)

        // Assert
    }

    func test_gameOver_player1WinsColumn_gameOverCalledWithPlayer1() {
        // Arrage
        let expectedWinner = Player.player1

        sut.gameOver = { player in
            XCTAssertEqual(player, expectedWinner)
        }

        // Act
        _ = sut.player(.player1, selected: 0)
        _ = sut.player(.player2, selected: 4)
        _ = sut.player(.player1, selected: 3)
        _ = sut.player(.player2, selected: 5)
        _ = sut.player(.player1, selected: 6)

        // Assert
    }

    func test_gameOver_player1WinsForwardDiagonal_gameOverCalledWithPlayer1() {
        // Arrage
        let expectedWinner = Player.player1

        sut.gameOver = { player in
            XCTAssertEqual(player, expectedWinner)
        }

        // Act
        _ = sut.player(.player1, selected: 0)
        _ = sut.player(.player2, selected: 2)
        _ = sut.player(.player1, selected: 4)
        _ = sut.player(.player2, selected: 5)
        _ = sut.player(.player1, selected: 8)

        // Assert
    }

    func test_gameOver_player1WinsBackwardDiagonal_gameOverCalledWithPlayer1() {
        // Arrage
        let expectedWinner = Player.player1

        sut.gameOver = { player in
            XCTAssertEqual(player, expectedWinner)
        }

        // Act
        _ = sut.player(.player1, selected: 2)
        _ = sut.player(.player2, selected: 1)
        _ = sut.player(.player1, selected: 4)
        _ = sut.player(.player2, selected: 5)
        _ = sut.player(.player1, selected: 6)

        // Assert
    }

    func test_gameOver_tieGame_gameOverCalledWithNil() {
        // Arrage
        let expectedWinner: Player? = nil

        sut.gameOver = { player in
            XCTAssertEqual(player, expectedWinner)
        }

        // Act
        _ = sut.player(.player1, selected: 0)
        _ = sut.player(.player1, selected: 2)
        _ = sut.player(.player1, selected: 5)
        _ = sut.player(.player1, selected: 6)
        _ = sut.player(.player1, selected: 7)

        _ = sut.player(.player2, selected: 1)
        _ = sut.player(.player2, selected: 3)
        _ = sut.player(.player2, selected: 4)
        _ = sut.player(.player2, selected: 8)

        // Assert
    }

    func test_gameOver_player2WinsRow_gameOverCalledWithPlayer1() {
        // Arrage
        let expectedWinner = Player.player2

        sut.gameOver = { player in
            XCTAssertEqual(player, expectedWinner)
        }

        // Act
        _ = sut.player(.player2, selected: 0)
        _ = sut.player(.player1, selected: 4)
        _ = sut.player(.player2, selected: 1)
        _ = sut.player(.player1, selected: 5)
        _ = sut.player(.player2, selected: 2)

        // Assert
    }

    func test_gameOver_player2WinsColumn_gameOverCalledWithPlayer1() {
        // Arrage
        let expectedWinner = Player.player2

        sut.gameOver = { player in
            XCTAssertEqual(player, expectedWinner)
        }

        // Act
        _ = sut.player(.player2, selected: 0)
        _ = sut.player(.player1, selected: 4)
        _ = sut.player(.player2, selected: 3)
        _ = sut.player(.player1, selected: 5)
        _ = sut.player(.player2, selected: 6)

        // Assert
    }

    func test_gameOver_player2WinsForwardDiagonal_gameOverCalledWithPlayer1() {
        // Arrage
        let expectedWinner = Player.player2

        sut.gameOver = { player in
            XCTAssertEqual(player, expectedWinner)
        }

        // Act
        _ = sut.player(.player2, selected: 0)
        _ = sut.player(.player1, selected: 2)
        _ = sut.player(.player2, selected: 4)
        _ = sut.player(.player1, selected: 5)
        _ = sut.player(.player2, selected: 8)

        // Assert
    }

    func test_gameOver_player2WinsBackwardDiagonal_gameOverCalledWithPlayer1() {
        // Arrage
        let expectedWinner = Player.player2

        sut.gameOver = { player in
            XCTAssertEqual(player, expectedWinner)
        }

        // Act
        _ = sut.player(.player2, selected: 2)
        _ = sut.player(.player1, selected: 1)
        _ = sut.player(.player2, selected: 4)
        _ = sut.player(.player1, selected: 5)
        _ = sut.player(.player2, selected: 6)

        // Assert
    }

    func test_gameOver_gameDataWriterCalledWithExpectedValue() {
        // Arrage
        let startDate = dateProvider.date
        let expectedValue = GameData(startTime: startDate,
                                     endTime: startDate.addingTimeInterval(367),
                                     winnerName: "Player 2",
                                     numberOfTurns: 3)

        let exp = expectation(description: "Save Data")
        gameDataWriting.writeLastGameDataCallback = { gameData in
            if gameData == expectedValue { exp.fulfill() }
        }

        // Act
        sut.startGame()
        dateProvider.offset = 367

        _ = sut.player(.player2, selected: 0)
        _ = sut.player(.player1, selected: 4)
        _ = sut.player(.player2, selected: 3)
        _ = sut.player(.player1, selected: 5)
        _ = sut.player(.player2, selected: 6)

        // Assert
        waitForExpectations(timeout: 1)
    }

    func test_gameOver_tie_game_gameDataWriterNotCalled() {
        // Arrage
        gameDataWriting.writeLastGameDataCallback = { gameData in
            XCTFail()
        }

        // Act
        sut.startGame()
        dateProvider.offset = 367

        _ = sut.player(.player1, selected: 0)
        _ = sut.player(.player1, selected: 2)
        _ = sut.player(.player1, selected: 5)
        _ = sut.player(.player1, selected: 6)
        _ = sut.player(.player1, selected: 7)

        _ = sut.player(.player2, selected: 1)
        _ = sut.player(.player2, selected: 3)
        _ = sut.player(.player2, selected: 4)
        _ = sut.player(.player2, selected: 8)

        // Assert
    }

    // MARK: - nameForPlayer

    func test_nameForPlayer_player1_nameIsExpectedValue() {
        // Arrage
        let epectedValue = "Player 1"

        // Act
        let result = sut.name(forPlayer: .player1)

        // Assert
        XCTAssertEqual(result, epectedValue)
    }

    func test_nameForPlayer_player2_nameIsExpectedValue() {
        // Arrage
        let epectedValue = "Player 2"

        // Act
        let result = sut.name(forPlayer: .player2)

        // Assert
        XCTAssertEqual(result, epectedValue)
    }
}
