//
//  CollectionView+TypeSafe.swift
//  Tic Tac Toe
//
//  Created by Chris Feher on 2020-03-30.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {

    func registerNibCell<T>(ofType type: T.Type) {
        let className = "\(type)"
        register(UINib(nibName: className, bundle: nil), forCellWithReuseIdentifier: className)
    }

    func deqeueNibCell<T>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        let className = "\(type)"
        return dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as! T
    }
}
