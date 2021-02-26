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

@testable import RaySays
import XCTest

class RaySaysTests: XCTestCase {
  func testGameCanPlaySuccessfulMove_length1() {
    let game = Game(pattern: [.one])
    let move = game.playMove(.one)
    XCTAssertEqual(move.state, GameState.won)
  }

  func testGameCanPlayFailingMove_length1() {
    let game = Game(pattern: [.one])
    let move = game.playMove(.two)
    XCTAssertEqual(move.state, GameState.lost)
  }

  func testGameCanPlaySuccessfulMove_length3() {
    let game = Game(pattern: [.one, .one, .three])
    let move1 = game.playMove(.one)
    XCTAssertEqual(move1.state, GameState.active)
    let move2 = move1.game.playMove(.one)
    XCTAssertEqual(move2.state, GameState.active)
    let move3 = move2.game.playMove(.three)
    XCTAssertEqual(move3.state, GameState.won)
  }

  func testGameCanPlayFailingMove_length3() {
    let game = Game(pattern: [.one, .one, .one])
    let move1 = game.playMove(.one)
    XCTAssertEqual(move1.state, GameState.active)
    let move2 = move1.game.playMove(.one)
    XCTAssertEqual(move2.state, GameState.active)
    let move3 = move2.game.playMove(.two)
    XCTAssertEqual(move3.state, GameState.lost)
  }

  func testGameCanPlayFailingMoveMidRange_length3() {
    let game = Game(pattern: [.one, .one, .one])
    let move1 = game.playMove(.one)
    XCTAssertEqual(move1.state, GameState.active)
    let move2 = move1.game.playMove(.two)
    XCTAssertEqual(move2.state, GameState.lost)
  }
}
