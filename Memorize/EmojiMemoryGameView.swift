import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack {
            HStack {
                Text("theme:")
                    .fontWeight(.semibold)
                Text(viewModel.theme.name)
                    .fontWeight(.bold)
                    .foregroundStyle(viewModel.theme.color)
                Spacer()
                Text("score:")
                Text(viewModel.score.description)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
            cards
                .animation(.default, value: viewModel.cards)
            Button("new game") {
                viewModel.start()
            }
        }
        .padding()
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card, theme: viewModel.theme)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    let theme: Theme<String>
    
    init(_ card: MemoryGame<String>.Card, theme: Theme<String>) {
        self.card = card
        self.theme = theme
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 15.0)
            Group {
                base
                    .fill(.white)
                    .strokeBorder(theme.color, lineWidth: 4)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill(theme.color)
                .strokeBorder(.black, lineWidth: 1)
                .opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

#Preview {
    let themeArrays = Array(EmojiMemoryGame.themes.values)
    let theme = themeArrays.randomElement()!
    return EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))
}
