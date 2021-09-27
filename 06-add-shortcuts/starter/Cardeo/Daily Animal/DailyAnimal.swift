/// Copyright (c) 2021 Razeware LLC
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

struct DailyAnimal: View {
  var animalName: String
  
  enum SequenceState {
    case inactive
    case pressing
    case manipulating
    
    var color: Color {
      switch self {
      case .pressing, .inactive:
        return .black
      case .manipulating:
        return .red
      }
    }
  }
  
  @GestureState private var gestureScale = CGFloat(0)
  @GestureState private var gestureRotation = Angle(degrees: 0)
  @GestureState private var gestureState = SequenceState.inactive
  
  @State private var scale = CGFloat(1.0)
  @State private var rotation = Angle(degrees: 0)
  
  var body: some View {
    let magnify = MagnificationGesture()
      .updating($gestureScale) { value, state, _ in
        state = (value - 1)
      }
    
    let rotate = RotationGesture()
      .updating($gestureRotation) { value, state, _ in
        state = value
      }
    
    let magnifyRotate = SimultaneousGesture(magnify, rotate)
      .onEnded { value in
        self.scale += (value.first ?? 0) - 1
        self.rotation += value.second ?? Angle(degrees: 0)
      }
    
    let pressMagnifyRotate = SequenceGesture(LongPressGesture(), magnifyRotate)
      .updating($gestureState) { value, state, _ in
        switch value {
        case .first(_):
          state = .pressing
        case .second(_, _):
          state = .manipulating
        }
      }
    
    return VStack(spacing: 50.0) {
      Text(animalName)
        .font(.largeTitle)
      
      Image(animalName)
        .resizable()
        .scaledToFit()
        .frame(width: 300, height: 300)
        .scaleEffect(scale + gestureScale)
        .rotationEffect(rotation + gestureRotation)
        .foregroundColor(gestureState.color)
        .gesture(pressMagnifyRotate)
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    DailyAnimal(animalName: starterAnimals.randomElement()!)
  }
}
