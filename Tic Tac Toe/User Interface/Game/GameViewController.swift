//
//  GameViewController.swift
//  Tic Tac Toe
//
//  Created by Chris Feher on 2020-03-30.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import UIKit

// MARK - Player

enum Player {
    case player1
    case player2

    static func player(for piece: Piece) -> Player? {
        switch piece {
            case .x: return .player1
            case .o: return .player2
            default: return nil
        }
    }

    var toggle: Player {
        switch self {
            case .player1: return .player2
            case .player2: return .player1
        }
    }

    var piece: Piece {
        switch self {
            case .player1: return .x
            case .player2: return .o
        }
    }

}

// MARK: - GameViewControllerViewModel

protocol GameViewControllerViewModel: class {
    // Flattened list representing game board - should be of length 9
    var selections: [TicTacToeSquareViewModel] { get }
    var gameOver: ((Player?) -> ())? { get set }

    func startGame()
    // returns true if the move is valid
    func player(_ player: Player, selected index: Int) -> Bool
    func name(forPlayer player: Player) -> String
}

// MARK: - GameViewController

class GameViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!

    let viewModel: GameViewControllerViewModel

    private var currentPlayer = Player.player2

    init(viewModel: GameViewControllerViewModel = GameViewModelImpl()) {
        self.viewModel = viewModel
        super.init(nibName: "GameViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        player1Label.transform = player1Label.transform.rotated(by: .pi)

        collectionView.registerNibCell(ofType: TicTacToeSquare.self)
        collectionView.dataSource = self
        collectionView.delegate = self

        configureViewModel()
        toggleTurn()
    }

    private func configureViewModel() {

        viewModel.gameOver = { [weak self] winner in
            self?.gameOver(winner: winner)
        }
    }

    private func gameOver(winner: Player?) {

        var description: String
        if let winner = winner { description = "\(viewModel.name(forPlayer: winner)) won the game" }
        else { description = "The game ended in a tie" }

        let alert = UIAlertController(title: "Game Over", message: description, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - Private Methods

private extension GameViewController {

    func toggleTurn() {
        currentPlayer = currentPlayer.toggle

        switch currentPlayer {
            case .player1:
                player2Label.alpha = 0.2
                player1Label.alpha = 1
            case .player2:
                player1Label.alpha = 0.2
                player2Label.alpha = 1
        }

        collectionView.reloadData()
    }
}

extension GameViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vm = viewModel.selections[indexPath.row]
        let cell = collectionView.deqeueNibCell(ofType: TicTacToeSquare.self, for: indexPath)
        cell.viewModel = vm
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.player(currentPlayer, selected: indexPath.row) {
            toggleTurn()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let widthHeight = (view.frame.size.width / 3) - (10 * 3)
        return CGSize(width: widthHeight, height: widthHeight)
    }
}
