//
//  ContentView.swift
//  Memorize
//
//  Created by Gabriel Nascimento on 27/07/24.
//

import SwiftUI

struct ContentView: View {
    
    let themes: [Theme: (emojis: [String], color: Color)] = [
        .vehicles: (["🚗", "🚚", "🚲", "🏍️", "🚂", "🚌", "🚎", "🚢", "⛵", "✈️", "🚁"], .vehicleColor),
        .plants: (["🌱", "🌿", "🍀", "🎋", "🌵", "🌴", "🌳", "🌲", "🌾", "🌷"], .plantColor),
        .foods: (["🍟", "🍔", "🍕", "🌭", "🍿", "🍦", "🍰", "🎂", "🍪", "🍩", "🍫", "🍭"], .foodColor)
    ]
    
    @State var selectedTheme: Theme? = .vehicles
    
    var body: some View {
        NavigationStack {
            VStack {
                if let theme = selectedTheme {
                    GeometryReader { geometry in
                        ScrollView {
                            cards(for: theme, availableWidth: geometry.size.width)
                        }
                        .padding(.horizontal)
                    }
                }
                else {
                    Spacer()
                    Text("Select a theme to start")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                
                themeButtons
                    .navigationTitle("Memorize")
            }
        }
    }
    
    private func cards(for theme: Theme, availableWidth: CGFloat) -> some View {
        let (emojis, color) = themes[theme] ?? ([], .white)
        
        let quantityOfCards = Int.random(in: 2..<emojis.count)
        let emojisArray = emojis[0..<quantityOfCards]
        let duplicatedEmojis = (emojisArray + emojisArray).shuffled()
        
        let cardWidth = maxCardWidth(for: duplicatedEmojis.count, availableWidth: availableWidth)
        
        return LazyVGrid(
            columns: [GridItem(.adaptive(minimum: cardWidth), spacing: 5)],
            spacing: 5
        ) {
            ForEach(duplicatedEmojis.indices, id: \.self) { index in
                Card(content: duplicatedEmojis[index], themeColor: color)
                    .aspectRatio(2/3, contentMode: .fill)
            }
        }
    }
    
    private func maxCardWidth(for cardsCount: Int, availableWidth: CGFloat) -> CGFloat {
        let ratio = 0.17
        let minCardWidth = availableWidth * ratio
        
        var result: CGFloat
        result = availableWidth
        if cardsCount == 2 {
            result = 120
        } else if cardsCount < 10 {
            result = 90
        } else if cardsCount < 17 {
            result = 85
        } else {
            result = minCardWidth
        }

        return result
    }
    
    var themeButtons: some View {
        HStack(spacing: 50) {
            ActionButton(
                label: "Vehicles",
                symbol: "car.circle",
                action: updateTheme,
                theme: .vehicles,
                selectedTheme: selectedTheme
            )
            ActionButton(
                label: "Plants",
                symbol: "leaf.circle",
                action: updateTheme,
                theme: .plants,
                selectedTheme: selectedTheme
            )
            ActionButton(
                label: "Foods",
                symbol: "fork.knife.circle",
                action: updateTheme,
                theme: .foods,
                selectedTheme: selectedTheme
            )
        }
        .padding()
    }
    
    private func updateTheme(to theme: Theme) {
        selectedTheme = theme
    }
}

enum Theme {
    case vehicles
    case plants
    case foods
}

extension Color {
    static let vehicleColor = Color(red: 70/255, green: 130/255, blue: 180/255)
    static let plantColor = Color(red: 34/255, green: 139/255, blue: 34/255)
    static let foodColor = Color(red: 255/255, green: 99/255, blue: 71/255)
}

struct Card: View {
    let content: String
    let themeColor: Color
    @State var isFaceUp = false
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 15.0)
            Group {
                base
                    .fill(.white)
                    .strokeBorder(themeColor, lineWidth: 4)
                Text(content)
                    .font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill(themeColor).opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

struct ActionButton: View {
    let label: String
    let symbol: String
    let action: (Theme) -> Void
    let theme: Theme
    let selectedTheme: Theme?
    
    var body: some View {
        Button(action: {
            action(theme)
        }) {
            VStack {
                Image(systemName: symbol)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .imageScale(.large)
                Text(label)
            }
        }
        .disabled(selectedTheme == theme)
    }
}

#Preview {
    ContentView()
}
