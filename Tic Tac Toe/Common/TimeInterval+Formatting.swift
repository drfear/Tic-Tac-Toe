//
//  TimeInterval+Formatting.swift
//  Tic Tac Toe
//
//  Created by Chris Feher on 2020-03-30.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import Foundation

extension TimeInterval {

  func format() -> String? {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.unitsStyle = .short
    formatter.maximumUnitCount = 2
    return formatter.string(from: self)
  }
}
