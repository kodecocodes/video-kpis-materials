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

class LoseViewController: UIViewController {
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var centralLabel: UILabel!
  @IBOutlet weak var centralView: UIStackView!
  @IBOutlet weak var speechBubble: UIView!
  let sadCat = "😿"
  let happyCat = "😸"
  var gameScore: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    scoreLabel.text = "\(gameScore)"
    speechBubble.alpha = UIDevice.current.userInterfaceIdiom == .pad ? 0 : 1
    configureGestures()
  }

  func configureGestures() {
    let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(goAway))
    view.addGestureRecognizer(tapToDismiss)
    centralView.isUserInteractionEnabled = true
    let hover = UIHoverGestureRecognizer(
      target: self,
      action: #selector(hoverOnCentralView(_:))
    )
    centralView.addGestureRecognizer(hover)
  }

  @objc func goAway() {
    dismiss(animated: true, completion: nil)
  }

  @objc func hoverOnCentralView(_ gesture: UIHoverGestureRecognizer) {
    let animationSpeed = 0.25
    switch gesture.state {
    //1
    case .began:
      centralLabel.text = happyCat
      UIView.animate(withDuration: animationSpeed ) {
        self.speechBubble.alpha = 1.0
        self.speechBubble.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
      }
    //2
    case .ended:
      centralLabel.text = sadCat
      UIView.animate(withDuration: animationSpeed ) {
        self.speechBubble.alpha = 0
        self.speechBubble.transform = .identity
      }
    default:
      print("message - unhandled state for hover")
    }
  }
}
