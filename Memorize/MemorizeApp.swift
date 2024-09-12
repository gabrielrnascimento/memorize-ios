//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Gabriel Nascimento on 27/07/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
