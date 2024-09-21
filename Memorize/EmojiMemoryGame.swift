//
//  EmojyMemoryGame.swift
//  Memorize
//
//  Created by Gabriel Nascimento on 09/09/24.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    @Published private var model: MemoryGame<String>
    
    var theme: Theme<String>

    private static func createMemoryGame(theme: Theme<String>) -> MemoryGame<String> {
        let content = theme.content.shuffled()
        return MemoryGame(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
            if content.indices.contains(pairIndex) {
                return content[pairIndex]
            } else {
                return "⁉"
            }
        }
    }
    
    init(theme: Theme<String>) {
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(theme: self.theme)
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    func randomTheme() {
        let themesArray = Array(EmojiMemoryGame.themes.values)
        theme = themesArray.randomElement()!
    }
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func start() {
        randomTheme()
        model = EmojiMemoryGame.createMemoryGame(theme: self.theme)
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
        guard model.hasPairsSelected else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            model.turnCardsDown()
        }
    }
}

extension EmojiMemoryGame {

    static let themes: [String: Theme<String>] = [
        "vehicles": Theme(
            name: "vehicles",
            content: ["🚗", "🚚", "🚲", "🏍️", "🚂", "🚌", "🚎", "🚢", "⛵", "✈️", "🚁"],
            color: .red,
            numberOfPairs: 8
        ),
        "plants": Theme(
            name: "plants",
            content: ["🌱", "🌿", "🍀", "🎋", "🌵", "🌴", "🌳", "🌲", "🌾", "🌷"],
            color: .green,
            numberOfPairs: 8
        ),
        "foods": Theme(
            name: "foods",
            content: ["🍟", "🍔", "🍕", "🌭", "🍿", "🍦", "🍰", "🎂", "🍪", "🍩", "🍫", "🍭"],
            color: .orange,
            numberOfPairs: 8
        ),
        "sports": Theme(
            name: "sports",
            content: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🎱", "🏓", "🏸"],
            color: .blue,
            numberOfPairs: 8
        ),
        "faces": Theme(
            name: "faces",
            content: ["😀", "😅", "😂", "🤣", "😊", "😇", "😉", "😍", "😜", "🤓", "😎", "😢"],
            color: .yellow,
            numberOfPairs: 8
        ),
        "weather": Theme(
            name: "weather",
            content: ["☀️", "🌤", "⛅️", "🌧", "⛈", "🌩", "❄️", "💨", "🌪", "🌈"],
            color: .purple,
            numberOfPairs: 8
        )
    ]
}


