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

struct InputForm: View {
  @State var name = ""
  @State var favoriteSnack = ""
  @State var hasFangs = false
  @State var fangLength = ""
  @State var description = ""
  
  enum Field {
    case name, snack, fangLength, description
  }
  
  @FocusState var focusedField: Field?
  
  var body: some View {
    VStack(alignment: .leading) {
      GroupBox {
        VStack(alignment: .leading, spacing: 6) {
          Text("Name")
          TextField("Enter Animal Name", text: $name)
            .focused($focusedField, equals: .name)
            .onSubmit(focusNextField)
            .submitLabel(.next)
        }
      }
      
      GroupBox {
        VStack(alignment: .leading, spacing: 6) {
          Text("Favorite Snack")
          TextField("Enter Favorite Snack", text: $favoriteSnack)
            .focused($focusedField, equals: .snack)
            .onSubmit(focusNextField)
            .submitLabel(.next)
        }
        
        Toggle("Has Fangs?", isOn: $hasFangs)
        
        if hasFangs {
          VStack(alignment: .leading, spacing: 6) {
            Text("Fang Length")
            TextField("Enter Fang Length", text: $fangLength)
              .keyboardType(.decimalPad)
              .focused($focusedField, equals: .fangLength)
          }
        }
      }

      GroupBox {
        VStack(alignment: .leading, spacing: 6) {
          Text("Description")
          TextEditor(text: $description)
            .frame(height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .focused($focusedField, equals: .description)
            .onSubmit(focusNextField)
            .submitLabel(.done)
        }
      }

      Portrait()
        .ignoresSafeArea(.keyboard)
    }
    .foregroundColor(.accentColor)
    .textFieldStyle(.roundedBorder)
    .padding(.horizontal)
    .tint(.accentColor)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItemGroup(placement: .keyboard) {
        Button(action: focusPreviousField) {
          Label("Previous", systemImage: "arrow.up")
        }
        .disabled(focusedField == .name)
        
        Button(action: focusNextField) {
          Label("Next", systemImage: "arrow.down")
        }
        .disabled(focusedField == .description)
        
        Spacer()
        
        Button("Done") {
          focusedField = nil
        }
      }
    }
  }
  
  private func focusPreviousField() {
    switch focusedField {
    case .name, .snack: focusedField = .name
    case .fangLength: focusedField = .snack
    case .description: focusedField = hasFangs ? .fangLength : .snack
    case .none: focusedField = nil
    }
  }
  
  private func focusNextField() {
    switch focusedField {
    case .name: focusedField = .snack
    case .snack: focusedField = hasFangs ? .fangLength : .description
    case .fangLength, .description: focusedField = .description
    case .none: focusedField = nil
    }
  }
}

struct Portrait: View {
  var body: some View {
    
    Image("Pallas Cat")
      .resizable()
      .scaledToFit()
      .foregroundColor(.black)
      .background{
        Color.accentColor
          .opacity(0.3)
          .clipShape(RoundedRectangle(cornerRadius: 16))
      }
  }
}

struct InputForm_Previews: PreviewProvider {
  static var previews: some View {
    InputForm()
  }
}

