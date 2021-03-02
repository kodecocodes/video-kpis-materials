//

import SwiftUI

struct ContentView: View {
  @State var textFieldString: String = ""
  
  @ObservedObject var keyboardHandler = KeyboardFollower()
  
  var body: some View {
    ScrollView {
      Image("welcomeArtwork")
      Image("welcomeArtwork")

      TextField(
        "Search…",
        text: $textFieldString
      )
      .padding(textFieldPadding)
      .background(textFieldBackground)
    }
    .padding(20)
    .offset(x: 0, y: -keyboardHandler.keyboardHeight)
    .edgesIgnoringSafeArea(keyboardHandler.isVisible ? .bottom : [])
  }
  
  //MARK: - Fancy TextField Styling
  let textFieldPadding = EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
  
  var textFieldBackground: some View {
    RoundedRectangle(cornerRadius: 9)
      .fill(Color.searchFieldBackground)
      .shadow(color: .searchFieldShadow, radius: 1, x: 0, y: 2)
      .overlay(
        RoundedRectangle(cornerRadius: 9)
          .stroke(Color.searchFieldBorder, lineWidth: 2)
      )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

