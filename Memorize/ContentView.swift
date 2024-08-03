//
//  ContentView.swift
//  Memorize
//
//  Created by Gabriel Nascimento on 27/07/24.
//

import SwiftUI

struct ContentView: View {
    let vehicleEmojiArray = ["🚗", "🚚", "🚲", "🏍️", "🚂", "🚌", "🚎", "🚢", "⛵", "✈️", "🚁"]
    let natureEmojiArray = ["🌱", "🌿", "🍀", "🎋", "🌵", "🌴", "🌳", "🌲", "🌾", "🌷"]
    let foodEmojiArray = ["🍟", "🍔", "🍕", "🌭", "🍿", "🍦", "🍰", "🎂", "🍪", "🍩", "🍫", "🍭"]
    
    @State var theme: [String] = []
    @State var themeIndex: Int = 4 // TODO improve this
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    cards
                }
                .padding(.horizontal)
                themeButtons
                    .navigationTitle("Memorize")
            }
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 65), spacing: 5)], spacing: 5) {
            ForEach(0..<theme.count, id: \.self) { index in
                Card(content: theme[index])
                    .aspectRatio(2/3, contentMode: .fill)
            }
        }
    }

    
    var themeButtons: some View {
        HStack(spacing: 50) {
            ActionButton(label: "Vehicles", symbol: "car.circle", index: 0, action: updateTheme, isDisabled: themeIndex == 0)
            ActionButton(label: "Plants", symbol: "leaf.circle", index: 1, action: updateTheme, isDisabled: themeIndex == 1)
            ActionButton(label: "Foods", symbol: "fork.knife.circle", index: 2, action: updateTheme, isDisabled: themeIndex == 2)
        }
        .padding()
    }
    
    private func updateTheme(to index: Int) {
        themeIndex = index
        let themeArray = [vehicleEmojiArray, natureEmojiArray, foodEmojiArray]
        let selectedTheme = themeArray[index]
        theme = (selectedTheme + selectedTheme).shuffled()
        
    }
}

struct Card: View {
    let content: String
    @State var isFaceUp = false
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 15.0)
            Group {
                base
                    .fill(.white)
                    .strokeBorder(.orange, lineWidth: 4)
                Text(content)
                    .font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill(.orange).opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

struct ActionButton: View {
    let label: String
    let symbol: String
    let index: Int
    let action: (Int) -> Void
    let isDisabled: Bool
    
    var body: some View {
            Button(action: {
                action(index)
            }) {
                VStack {
                    Image(systemName: symbol)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .imageScale(.large)
                    Text(label)
                }
            }
            .disabled(isDisabled)
    }
}

#Preview {
    ContentView()
}
