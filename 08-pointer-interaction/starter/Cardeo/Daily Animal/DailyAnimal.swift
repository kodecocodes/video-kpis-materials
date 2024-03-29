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
  @State private var animalName: String = starterAnimals.randomElement()!
  @State private var isPreviewPresented = false
  
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
      
      HStack {
        Button
        { self.animalName = starterAnimals.randomElement()! }
        label: {
          Text("New Animal")
            .font(.title2)
            .foregroundColor(.white)
            .padding()
            .background(
              Color.accentColor
            )
            .cornerRadius(12)
        }
        .keyboardShortcut("n", modifiers: [])
        // TODO: - Add Hover Effect
        
        Button("All Animals") {
          isPreviewPresented = true
        }
        .font(.title2)
        .keyboardShortcut("p", modifiers: [])
        // TODO: - Add Hover Effect
      }
      .fullScreenCover(isPresented: $isPreviewPresented) {
        animalCollection(selectedAnimal: $animalName, isPresented: $isPreviewPresented)
      }
    }
  }
}

struct AnimalView: View {
  let animal: String
  let onTap: (String) -> Void
  let roundedRectangle = RoundedRectangle(cornerRadius: 12)
  
  // TODO: - Add @State Bool
  
  var body: some View {
    Button {
      onTap(animal)
    }
    label: {
      ZStack(alignment: .bottom) {
        roundedRectangle
          .fill(Color.white)
          // TODO: - Shadow with isHovering
          .shadow(radius: 3)
        
        AnimalImage(animal: animal)
        // TODO: - Scale with isHovering
        
        // TODO: - Check isHovering
        AnimalText(animal: animal)
          .background(Color.accentColor)
          .clipShape(roundedRectangle)
      }
    }
    // TODO: - Add onHover
  }
}


struct animalCollection: View {
  @Binding var selectedAnimal: String
  @Binding var isPresented: Bool
  
  var columns = [GridItem(.adaptive(minimum: 200, maximum: 300), spacing: 24)]
  
  func tap(animal: String) {
    selectedAnimal = animal
    isPresented = false
  }
  
  var body: some View {
    LazyVGrid(columns: columns, spacing: 24) {
      ForEach(starterAnimals, id: \.self) { animal in
        AnimalView(animal: animal, onTap: tap(animal:))
      }
    }
    .padding()
  }
}

struct AnimalText: View {
  let animal: String
  
  var body: some View {
    HStack {
      Spacer()
      Text(animal)
        .font(.headline)
        .lineLimit(1)
        .foregroundColor(.white)
        .padding(.vertical)
      Spacer()
    }
  }
}

struct AnimalImage: View {
  let animal: String
  
  var body: some View {
    Image(animal)
      .resizable()
      .padding(12)
      .scaledToFill()
      .foregroundColor(.black)
  }
}


struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    DailyAnimal()
  }
}
