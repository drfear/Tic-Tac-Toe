//
//  GameViewModelImpl.swift
//  Tic Tac Toe
//
//  Created by Chris Feher on 2020-03-30.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import Foundation

// MARK: - GameViewModelImpl

class GameViewModelImpl {

    var gameOver: ((Player?) -> ())?
    var player1Name: String = "Player 1"
    var player2Name: String = "Player 2"

    // game state
    private var startTime = Date()
    private var moveCount: Int = 0
    private var matrix: SquareMatrix<TicTacToeSquareViewModel>

    private let gameDataWriting: GameDataWriting
    private let dateProvider: DateProvider

    init(gameDataWriting: GameDataWriting = GameDataProviderImpl(),
         dateProvider: DateProvider = DateProviderImpl()) {
        let emptySelections = (0..<9).map { _ in TicTacToeSquareViewModelImpl(piece: .empty) }
        matrix = SquareMatrix(data: emptySelections)!
        self.gameDataWriting = gameDataWriting
        self.dateProvider = dateProvider
    }
}

// MARK: - GameViewControllerViewModel Methods

extension GameViewModelImpl: GameViewControllerViewModel {

    var selections: [TicTacToeSquareViewModel] {
        return matrix.data
    }

    func startGame() {
        startTime = dateProvider.date
        moveCount = 0
    }

    func player(_ player: Player, selected index: Int) -> Bool {
        var selections = matrix.data
        let square = selections[index]
        if square.piece.isEmpty {
            selections[index] = TicTacToeSquareViewModelImpl(piece: player.piece)
            matrix = SquareMatrix(data: selections)!
            inputRegistered()
        }
        return square.piece.isEmpty
    }

    func name(forPlayer player: Player) -> String {
        switch player {
            case .player1: return player1Name
            case .player2: return player2Name
        }
    }
}

// MARK: - Private methods

private extension GameViewModelImpl {

    func incrementTurnCount() {
        moveCount += 1
    }

    func inputRegistered() {
        incrementTurnCount()
        checkForGameOver()
    }

    func checkForGameOver() {

        let mapper = { (row: [TicTacToeSquareViewModel]) -> [Piece] in
            return row.map { $0.piece }
        }

        let winnerFilter: ([Piece]) -> Bool = { row in
            guard let first = row.first, !first.isEmpty else { return false }
            return row.allSatisfy { $0 == first }
        }

        let winners = matrix.rows.map(mapper).filter(winnerFilter) +
            matrix.columns.map(mapper).filter(winnerFilter) +
            matrix.diagonals.map(mapper).filter(winnerFilter)

        if let winner = winners.first,
            let piece = winner.first,
            let player = Player.player(for: piece) {
                initiateGameOver(withWinner: player)
        } else if selections.filter({ $0.piece.isEmpty }).isEmpty {
            initiateGameOver(withWinner: nil)
        }
    }

    func initiateGameOver(withWinner winner: Player?) {
        guard let winner = winner else {
            gameOver?(nil)
            return
        }
        save(winnerName: name(forPlayer: winner))
        gameOver?(winner)
    }

    func save(winnerName name: String) {
        let turns: Int = Int(round(Float(moveCount) / 2))
        let gammeSave = GameData(startTime: startTime,
                                 endTime: dateProvider.date,
                                 winnerName: name,
                                 numberOfTurns: turns)
        gameDataWriting.writeLastGameData(gammeSave)
    }
}
