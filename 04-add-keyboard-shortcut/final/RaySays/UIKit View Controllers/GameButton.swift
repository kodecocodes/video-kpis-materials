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

class GameButton: UIView {
var pointerLocation: CGPoint = .zero {
  didSet {
    setNeedsDisplay()
  }
}

var pointerInside = false {
  didSet {
    setNeedsDisplay()
  }
}

  var color: UIColor = .blue {
    didSet {
      layer.backgroundColor = color.cgColor
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    let interaction = UIPointerInteraction(delegate: self)
    addInteraction(interaction)
    backgroundColor = .clear
    layer.cornerRadius = 10.0
    layer.backgroundColor = color.cgColor
  }

  func highlight() {
    let baseColor = layer.backgroundColor
    let animation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
    animation.fromValue = baseColor
    animation.toValue = UIColor.white.cgColor
    animation.duration = 0.4
    animation.autoreverses = true
    layer.add(animation, forKey: #keyPath(CALayer.backgroundColor))
  }

  var blobSize = CGFloat(50)
  override func draw(_ rect: CGRect) {
    if pointerInside {
      let blob = UIBezierPath(ovalIn: CGRect(center: pointerLocation, size: blobSize))
      UIColor.white.set()
      blob.fill()
    }
  }
}

extension GameButton: UIPointerInteractionDelegate {
  func pointerInteraction(
    _ interaction: UIPointerInteraction,
    regionFor request: UIPointerRegionRequest,
    defaultRegion: UIPointerRegion
  ) -> UIPointerRegion? {
    pointerLocation = request.location
    return defaultRegion
  }

  func pointerInteraction(
    _ interaction: UIPointerInteraction,
    styleFor region: UIPointerRegion
  ) -> UIPointerStyle? {
    let hand = UIBezierPath(svgPath: AppShapeStrings.hand, offset: 24)
    return UIPointerStyle(shape: UIPointerShape.path(hand))
  }

  func pointerInteraction(
    _ interaction: UIPointerInteraction,
    willEnter region: UIPointerRegion,
    animator: UIPointerInteractionAnimating
  ) {
    pointerInside = true
  }

  func pointerInteraction(
    _ interaction: UIPointerInteraction,
    willExit region: UIPointerRegion,
    animator: UIPointerInteractionAnimating
  ) {
    pointerInside = false
    let animation = animateOut(pointerLocation)
    animator.addAnimations(animation.animation)
    animator.addCompletion { _ in
      animation.animatedView.removeFromSuperview()
    }
  }
}

extension GameButton {
  func animateOut(_ origin: CGPoint)
    -> (animatedView: UIView, animation: () -> Void) {
      let blob = UIView(frame: CGRect(center: origin, size: blobSize))
      blob.backgroundColor = UIColor.white
      blob.layer.cornerRadius = blobSize / 2
      self.addSubview(blob)
      return (blob, {
        blob.frame = CGRect(center: self.bounds.center, size: self.blobSize / 10)
        blob.layer.cornerRadius = self.blobSize / 20
        blob.backgroundColor = self.color
      })
  }
}
