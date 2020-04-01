//
//  StartViewModelImpl.swift
//  Tic Tac Toe
//
//  Created by Chris Feher on 2020-03-30.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import Foundation

// MARK: - StartViewModelImpl

class StartViewModelImpl {

    var gameDataUpdated: (() -> ())?

    private let gameDataReading: GameDataReading
    private var lastGameData: GameData?

    init(gameDataReading: GameDataReading = GameDataProviderImpl()) {
        self.gameDataReading = gameDataReading
    }
}

// MARK: StartViewControllerViewModel Methods

extension StartViewModelImpl: StartViewControllerViewModel {

    var formattedLastGameTime: String? {
        guard let lastGameData = lastGameData else { return nil }
        return lastGameData.endTime.timeIntervalSince(lastGameData.startTime).format()
    }

    var lastWinnerName: String? {
        return lastGameData?.winnerName
    }

    var lastGameNumberOfTurns: Int? {
        return lastGameData?.numberOfTurns
    }

    func updateGameData() {
        lastGameData = gameDataReading.getLastGameData()
        gameDataUpdated?()
    }
}
