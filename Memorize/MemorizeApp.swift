//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Gabriel Nascimento on 27/07/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game: EmojiMemoryGame
    
    init() {
        let themesArray = Array(EmojiMemoryGame.themes.values)
        let theme = themesArray.randomElement()!
        _game = StateObject(wrappedValue: EmojiMemoryGame(theme: theme))
    }
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
