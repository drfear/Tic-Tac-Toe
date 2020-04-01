//
//  GameDataProvider.swift
//  Tic Tac Toe
//
//  Created by Chris Feher on 2020-03-30.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import Foundation

// MARK: - GameData

struct GameData: Codable, Equatable {
    let startTime: Date
    let endTime: Date
    let winnerName: String
    let numberOfTurns: Int
}

// MARK: - GameDataReading

protocol GameDataReading {

    func getLastGameData() -> GameData?
}

// MARK: - GameDataWriting

protocol GameDataWriting {

    func writeLastGameData(_ gameData: GameData)
}

// MARK: - GameDataProvider

protocol GameDataProvider: GameDataReading, GameDataWriting { }

// MARK: - GameDataProvider

class GameDataProviderImpl {

    private static let gameDataStorageKey = "GAME_DATA_STORAGE"

    let storage: PersistentStorage

    init(storage: PersistentStorage = UserDefaultsPersistentStorageImpl()) {
        self.storage = storage
    }
}

// MARK: - GameDataProvider Conformance

extension GameDataProviderImpl: GameDataProvider { }

// MARK: - GameDataReading Methods

extension GameDataProviderImpl: GameDataReading {

    func getLastGameData() -> GameData? {
        if let data = storage.getData(forKey: GameDataProviderImpl.gameDataStorageKey) {
            let gameData = try? JSONDecoder().decode(GameData.self, from: data)
            return gameData
        }
        return nil
    }
}

// MARK: - GameDataWriting Methods

extension GameDataProviderImpl: GameDataWriting {

    func writeLastGameData(_ gameData: GameData) {
        let data = try? JSONEncoder().encode(gameData)
        storage.set(data, forKey: GameDataProviderImpl.gameDataStorageKey)
    }
}
