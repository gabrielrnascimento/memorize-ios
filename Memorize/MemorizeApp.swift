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
