//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Gabriel Nascimento on 27/07/24.
//

import SwiftUI

// View
struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3
    
    @State var selectedTheme: Theme? = .vehicles
    
    var body: some View {
        NavigationStack {
            VStack {
                cards
                    .animation(.default, value: viewModel.cards)
                Button("Shuffle") {
                    viewModel.shuffle()
                }
            }
            .padding()
            .navigationTitle("Memorize")
        }
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
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

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 15.0)
            Group {
                base
                    .fill(.white)
                    .strokeBorder(.red, lineWidth: 4)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill(.orange)
                .opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
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
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
