//
//  PersistentStorage.swift
//  Tic Tac Toe
//
//  Created by Chris Feher on 2020-03-30.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import Foundation

// MARK: - PersistentStorage

protocol PersistentStorage {

    func set(_ data: Data?, forKey key: String)
    func getData(forKey key: String) -> Data?
}

// MARK: - UserDefaultsPersistentStorageImpl

class UserDefaultsPersistentStorageImpl: PersistentStorage {

    private let defaults = UserDefaults.standard

    func set(_ data: Data?, forKey key: String) {
        defaults.set(data, forKey: key)
    }

    func getData(forKey key: String) -> Data? {
        return defaults.data(forKey: key)
    }
}
