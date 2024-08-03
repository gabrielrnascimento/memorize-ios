//
//  ContentView.swift
//  Memorize
//
//  Created by Gabriel Nascimento on 27/07/24.
//

import SwiftUI

struct ContentView: View {
    let emojis = ["👻", "🎃", "🕷", "🕸", "🦇", "🧛‍♂️", "🧟‍♀️", "🧙‍♀️", "🪦", "🧹", "🍬", "🍫"]
    
    @State var cardCount: Int = 4
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    cards
                }
                .padding(.horizontal)
            }
            .navigationTitle("Memorize")
        }
        
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                Card(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fill)
            }
        }
        .padding()
    }
}

struct Card: View {
    let content: String
    @State var isFaceUp = false
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 25.0)
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

#Preview {
    ContentView()
}
