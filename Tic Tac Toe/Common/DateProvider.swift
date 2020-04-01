//
//  DateProvider.swift
//  Tic Tac Toe
//
//  Created by Chris Feher on 2020-03-31.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import Foundation

// MARK: - DateProvider

protocol DateProvider {
    var date: Date { get }
}

// MARK: - DateProviderImpl

class DateProviderImpl: DateProvider {

    var date: Date {
        return Date()
    }
}
