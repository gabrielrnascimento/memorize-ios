//
//  EmojyMemoryGame.swift
//  Memorize
//
//  Created by Gabriel Nascimento on 09/09/24.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private static let emojis = ["🚗", "🚚", "🚲", "🏍️", "🚂", "🚌", "🚎", "🚢", "⛵", "✈️", "🚁"]
    
    // TODO: Add themes
//    private static let themes: [Theme: (emojis: [String], color: Color)] = [
//        .vehicles: (["🚗", "🚚", "🚲", "🏍️", "🚂", "🚌", "🚎", "🚢", "⛵", "✈️", "🚁"], .vehicleColor),
//        .plants: (["🌱", "🌿", "🍀", "🎋", "🌵", "🌴", "🌳", "🌲", "🌾", "🌷"], .plantColor),
//        .foods: (["🍟", "🍔", "🍕", "🌭", "🍿", "🍦", "🍰", "🎂", "🍪", "🍩", "🍫", "🍭"], .foodColor)
//    ]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 8) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "⁉"
            }
        }
    }
        
    @Published private var model = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
}
