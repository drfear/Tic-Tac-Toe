//
//  Matrix.swift
//  Tic Tac Toe
//
//  Created by Chris Feher on 2020-04-01.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import Foundation

class SquareMatrix<T> {

    let data: [T]
    private let length: Int

    init?(data: [T]) {
        let doubleLength = sqrt(Double(data.count))
        guard doubleLength.truncatingRemainder(dividingBy: 1) == 0 else { return nil }
        self.length = Int(doubleLength)
        self.data = data
    }

    var rows: [[T]] {
        return data.reduce([[T]]()) { rows, element in
            if let last = rows.last, last.count < length {
                return rows.dropLast() + [last + [element]]
            } else {
                return rows + [[element]]
            }
        }
    }

    var columns: [[T]] {
        let cols = (0..<length).map {_ in [T]() }
        return data.enumerated().reduce(into: cols) { columns, pair in
            let column = pair.offset % length
            columns[column].append(pair.element)
        }
    }

    var diagonals: [[T]] {

        // forward
        let (_, forward) = rows.reduce((0, [T]())) { result, row in
            let index = result.0
            let diagonals = result.1
            let valueToInsert = row[index]
            return (index + 1, diagonals + [valueToInsert])
        }

        // backward
        let (_, backward) = rows.reduce((length - 1, [T]())) { result, row in
            let index = result.0
            let diagonals = result.1
            let valueToInsert = row[index]
            return (index - 1, diagonals + [valueToInsert])
        }

        return [forward, backward]
    }
}
