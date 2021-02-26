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

import Foundation
import Combine

protocol GamePresenter {
  func displayUnit(_ unit: GameUnit)
  func displayGameLost(_ game: Game)
  func displayRoundWon(_ game: Game)
  func scoreDidUpdate(score: Int, highScore: Int)
}

class GameEngine: ObservableObject {
  enum State {
    case paused
    case displayPattern
    case receivePattern
    case success
    case fail
  }

  @Published private(set) var score = 0
  @Published private(set) var state = State.paused

  private var activeGame = Game()
  private var currentDisplayMove = 0
  private var moveDelay: TimeInterval = 1.0 /// time between moves
  private var interRoundDelay: TimeInterval = 3.0 /// time between rounds

  @Published var signalOne: Bool = false
  @Published var signalTwo: Bool = false
  @Published var signalThree: Bool = false
  @Published var signalFour: Bool = false
  @Published var displayWin: Bool = false
  @Published var displayLose: Bool = false

  var presenter: GamePresenter?
  let difficulty: Difficulty

  init(presenter: GamePresenter?, difficulty: Difficulty = .easy) {
    self.presenter = presenter
    self.difficulty = difficulty
    moveDelay = difficulty.speed
  }

  func createGame(length: Int) -> Game {
    guard length > 0 else {
      assertionFailure("game should have a lenth of > 0")
      return Game()
    }

    let units = (0..<length).map { _ in
      GameUnit.random()
    }
    return Game(pattern: units)
  }

  func playGame() {
    guard state == .paused || state  == .success || state  == .fail else {
      return
    }

    state = .displayPattern
    activeGame = createGame(length: score + 1)
    displaySequence()
  }

  private func playNextRound() {
    _ = Timer.scheduledTimer(
      withTimeInterval: interRoundDelay,
      repeats: false) { [weak self] _ in
        self?.playGame()
    }
  }

  private func displaySequence() {
    /// if state is not .displayPattern on entry, game is either reset or engine is broken
    guard state == .displayPattern else {
      return
    }

    guard currentDisplayMove < activeGame.pattern.count else {
      currentDisplayMove = 0
      startReceiving()
      return
    }

    let unit = activeGame.pattern[currentDisplayMove]
    doDisplayUnit(unit)
    currentDisplayMove += 1
    _ = Timer.scheduledTimer(
      withTimeInterval: moveDelay,
      repeats: false) { [weak self] _ in
        self?.displaySequence()
    }
  }

  private func startReceiving() {
    guard state == .displayPattern else { return }
    state = .receivePattern
  }

  func receiveMove(_ unit: GameUnit) {
    guard state == .receivePattern else { return }

    doDisplayUnit(unit)

    let result = activeGame.playMove(unit)
    activeGame = result.game
    switch result.state {
    case .active:
      print("next move!")
    case .lost:
      state  = .fail
      doDisplayGameLost()
    case .won:
      incrementScore()
      state  = .success
      doDisplayGameWon()
      playNextRound()
    }
  }

  private func doDisplayUnit(_ unit: GameUnit) {
    presenter?.displayUnit(unit)
    displayUnit(unit)
  }

  private func doDisplayGameLost() {
    presenter?.displayGameLost(activeGame)
    displayLose = true
  }

  private func doDisplayGameWon() {
    presenter?.displayRoundWon(activeGame)
    displayWin = true
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
      self.displayWin = false
    }
  }

  func reset() {
    state = .paused
    score = 0
    displayWin = false
    displayLose = false
    presenter?.scoreDidUpdate(score: score, highScore: highScore)
  }

  func toggleIsPlaying() {
    if isPlaying {
      reset()
    } else {
      reset()
      playGame()
    }
  }

  let kHighScoreKey = "HighScore"
  func incrementScore() {
    objectWillChange.send()
    score += 1
    if score > highScore {
      UserDefaults.standard.set(score, forKey: kHighScoreKey)
    }
    presenter?.scoreDidUpdate(score: score, highScore: highScore)
  }

  var highScore: Int {
    return UserDefaults.standard.integer(forKey: kHighScoreKey)
  }

  var isPlaying: Bool {
    return state == .receivePattern || state == .displayPattern || state == .success
  }

  func displayUnit(_ unit: GameUnit) {
    var instruction = { }

    switch unit {
    case .one:
      instruction = {
        self.signalOne.toggle()
      }
    case .two:
      instruction = {
        self.signalTwo.toggle()
      }
    case .three:
      instruction = {
        self.signalThree.toggle()
      }
    case .four:
      instruction = {
        self.signalFour.toggle()
      }
    }

    instruction()
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
      instruction()
    }
  }
}
