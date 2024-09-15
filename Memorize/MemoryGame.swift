//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Gabriel Nascimento on 09/09/24.
//

import Foundation


struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score = 0
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
        cards.shuffle()
    }
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set { return cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        score += 2
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                    } else {
                        if cards[chosenIndex].flipCount > 1 || cards[potentialMatchIndex].flipCount > 1 {
                            score -= 1
                        }
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func start() {
        self.shuffle()
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "") flipped: \(flipCount)"
        }
        
        var isFaceUp: Bool {
            get { return _isFaceUp }
            set { if newValue && !_isFaceUp { flipCount += 1 }; _isFaceUp = newValue; print(self) }
        }
        private var _isFaceUp = false
        var isMatched = false
        let content: CardContent
        var flipCount = 0
        
        var id: String
        
        init(isMatched: Bool = false, content: CardContent, id: String) {
            self._isFaceUp = false
            self.isMatched = isMatched
            self.content = content
            self.flipCount = 0
            self.id = id
        }
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
