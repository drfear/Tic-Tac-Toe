//
//  TicTacToeSquare.swift
//  Tic Tac Toe
//
//  Created by Chris Feher on 2020-03-30.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import UIKit

// MARK: piece

enum Piece {
    case x
    case o
    case empty

    var isX: Bool {
        switch self {
            case .x: return true
            default: return false
        }
    }

    var isO: Bool {
        switch self {
            case .o: return true
            default: return false
        }
    }

    var isEmpty: Bool {
        switch self {
            case .empty: return true
            default: return false
        }
    }
}

// MARK: - TicTacToeSquareViewModel

protocol TicTacToeSquareViewModel {
    var piece: Piece { get }
}

// MARK: TicTacToeSquareViewModelImpl

struct TicTacToeSquareViewModelImpl: TicTacToeSquareViewModel {
    let piece: Piece
}

// MARK: - TicTacToeSquare

class TicTacToeSquare: UICollectionViewCell {

    @IBOutlet private var pieceLabel: UILabel!

    var viewModel: TicTacToeSquareViewModel? {
        didSet {
            configureViewModel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configureViewModel()
    }

    private func configureViewModel() {
        guard let viewModel = viewModel, !viewModel.piece.isEmpty else {
            pieceLabel.text = nil
            return
        }

        pieceLabel.text = viewModel.piece.isX ? "X" : "O"
    }
}
