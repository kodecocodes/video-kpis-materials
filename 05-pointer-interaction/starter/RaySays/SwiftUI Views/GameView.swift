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

import SwiftUI

struct GameView: View {
  init(gameEngine engine: GameEngine) {
    gameEngine = engine
  }

  var hasOverlay: Bool {
    return gameEngine.displayWin || gameEngine.displayLose
  }

  @ObservedObject var gameEngine: GameEngine

  var body: some View {
    ZStack {
      VStack(alignment: .center, spacing: 0) {
        HStack {
          Text("Score: \(gameEngine.score)")
            .font(Font(UIFont.gameFont(ofSize: 72)))
          Spacer()
          Text("High score: \(gameEngine.highScore)")
            .font(Font(UIFont.gameFont(ofSize: 40)))
        }
        .padding()
        Spacer()
        GameKeyboard(gameEngine: gameEngine)
          .padding(EdgeInsets(top: 0, leading: 60, bottom: 20, trailing: 60))
        Spacer()
        //swiftlint:disable multiple_closures_with_trailing_closure
        Button(
          action: {
          self.playAction()
          }) {
          ZStack {
            Text(self.gameEngine.isPlaying ? "Reset" : "Play")
              .font(Font(UIFont.systemFont(ofSize: 25)))
              .padding(EdgeInsets(top: 4, leading: 40, bottom: 4, trailing: 40))
              .foregroundColor(.white)
              //swiftlint:disable force_unwrapping
              .background(self.gameEngine.isPlaying ? Color.orange : Color(UIColor(named: "rw-green")!))
          }
          .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
          //add button hover here
        }
      }
      .blur(radius: hasOverlay ? 30 : 0)
      if gameEngine.displayWin {
        WinView()
      }
      if gameEngine.displayLose {
        LoseView(score: gameEngine.score)
          .onTapGesture {
            self.gameEngine.reset()
          }
      }
    }
  }
}

struct GameView_Previews: PreviewProvider {
  static var previews: some View {
    let gameEngine = GameEngine(presenter: nil)
    return GameView(gameEngine: gameEngine)
  }
}

extension GameView {
  func playAction() {
    if gameEngine.isPlaying {
      gameEngine.reset()
    } else {
      gameEngine.reset()
      gameEngine.playGame()
    }
  }
}
