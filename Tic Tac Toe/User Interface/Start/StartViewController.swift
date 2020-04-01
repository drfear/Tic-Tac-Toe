//
//  StartViewController.swift
//  Tic Tac Toe
//
//  Created by Chris Feher on 2020-03-30.
//  Copyright © 2020 Chris Feher. All rights reserved.
//

import UIKit

// MARK: - StartViewControllerViewModel

protocol StartViewControllerViewModel {
    var lastWinnerName: String? { get }
    var lastGameNumberOfTurns: Int? { get }
    var formattedLastGameTime: String? { get }

    var gameDataUpdated: (() -> ())? { get set }
    func updateGameData()
}

// MARK: - StartViewController

class StartViewController: UIViewController {

    @IBOutlet private var winnerNameLabel: UILabel!
    @IBOutlet private var numberOfTurnsLabel: UILabel!
    @IBOutlet private var gameTimeLabel: UILabel!

    var viewModel: StartViewControllerViewModel

    init(viewModel: StartViewControllerViewModel = StartViewModelImpl()) {
        self.viewModel = viewModel
        super.init(nibName: "StartViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Tic Tac Toe"

        viewModel.gameDataUpdated = { [weak self] in
            self?.setupViewModel()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.updateGameData()
    }
}

// MARK: - Private Methods

private extension StartViewController {

    func setupViewModel() {
        winnerNameLabel.text = viewModel.lastWinnerName ?? "None"
        numberOfTurnsLabel.text = "\(viewModel.lastGameNumberOfTurns ?? 0)"
        gameTimeLabel.text = viewModel.formattedLastGameTime ?? "0:00"
    }

    @IBAction @objc private func newGameButtonPressed() {
        let gameViewController = GameViewController()
        navigationController?.pushViewController(gameViewController, animated: true)
    }
}
