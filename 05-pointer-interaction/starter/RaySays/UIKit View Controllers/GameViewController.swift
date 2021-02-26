/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class GameViewController: UIViewController {
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var highScoreLabel: UILabel!
  @IBOutlet weak var resetPlayButton: UIButton!

  @IBOutlet weak var one: GameButton!
  @IBOutlet weak var two: GameButton!
  @IBOutlet weak var three: GameButton!
  @IBOutlet weak var four: GameButton!

  @IBOutlet var allButtons: [GameButton]!
  let allColors: [UIColor] = [.red, .green, .blue, .yellow]

  lazy var gameEngine: GameEngine = {
    let value = UserDefaults.standard.integer(forKey: kDifficultyPrefsKey)
    let difficulty = Difficulty(rawValue: value) ?? .easy
    return GameEngine(presenter: self, difficulty: difficulty )
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureGameButtons()
    configureResetPlayButton(gameEngine)
    scoreDidUpdate(score: 0, highScore: gameEngine.highScore)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let lvc = segue.destination as? LoseViewController {
      lvc.gameScore = gameEngine.score
    }
  }

  func configureResetPlayButton(_ gameEngine: GameEngine) {
    if gameEngine.isPlaying {
      resetPlayButton.setTitle("Reset", for: .normal)
      resetPlayButton.backgroundColor = UIColor.systemOrange
    } else {
      resetPlayButton.setTitle("Play", for: .normal)
      resetPlayButton.backgroundColor = UIColor(named: "rw-green")
    }
  }

  func configureGameButtons() {
    for (index, item) in zip(allColors, allButtons).enumerated() {
      let button = item.1
      let color = item.0

      button.color = color
      button.tag = index

      let tapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(gameButtonAction(_:))
      )
      button.addGestureRecognizer(tapGesture)
    }
  }

  @objc func gameButtonAction(_ tapGesture: UITapGestureRecognizer) {
    guard tapGesture.state == .ended else {
      return
    }

    guard
      let tag = tapGesture.view?.tag,
      let unit = GameUnit(rawValue: tag)
      else {
        assertionFailure("button tag didnt map to Unit case")
        return
    }

    gameEngine.receiveMove(unit)
  }

  @IBAction func playAction(_ sender: Any) {
    gameEngine.toggleIsPlaying()
    configureResetPlayButton(gameEngine)
  }
}

extension GameViewController: GamePresenter {
  func scoreDidUpdate(score: Int, highScore: Int) {
    scoreLabel.text = "\(score)"
    highScoreLabel.text = "\(highScore)"
  }

  func displayUnit(_ unit: GameUnit) {
    guard gameEngine.isPlaying else {
      return
    }
    switch unit {
    case .one:
      one.highlight()
    case .two:
      two.highlight()
    case .three:
      three.highlight()
    case .four:
      four.highlight()
    }
  }

  func displayGameLost(_ game: Game) {
    configureResetPlayButton(gameEngine)
    performSegue(withIdentifier: "ShowLose", sender: self)
  }

  func displayRoundWon(_ game: Game) {
    configureResetPlayButton(gameEngine)
    performSegue(withIdentifier: "ShowWin", sender: self)
  }
}
