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
    private(set) var hasPairsSelected = false
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
        cards.shuffle()
    }
    
    var indexOfCardToBeMatched: Int?
    
    // FIXME: - Same card being selected and compared with itself
    // 1. select card A
    // 2. select card B (different content)
    // 3. select multiple times card B within the vanish time
    mutating func turnCardsDown() {
        hasPairsSelected = false
        indexOfCardToBeMatched = nil
        cards.indices.forEach { index in
            cards[index].isFaceUp = false
        }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched,
            !hasPairsSelected {
            handleCardSelection(at: chosenIndex)
        }
    }
    
    mutating private func handleCardSelection(at chosenIndex: Int) {
        cards[chosenIndex].isFaceUp = true
        guard indexOfCardToBeMatched != nil else {
            indexOfCardToBeMatched = chosenIndex
            return
        }
        
        if let index = indexOfCardToBeMatched {
            checkForMatch(between: index, and: chosenIndex)
        }
    }
    
    mutating private func checkForMatch(between chosenIndex: Int, and potentialMatchIndex: Int) {
        if cards[chosenIndex].content == cards[potentialMatchIndex].content {
            matchCards(between: chosenIndex, and: potentialMatchIndex)
        } else {
            penalizeMismatch(between: chosenIndex, and: potentialMatchIndex)
        }
        hasPairsSelected = true
    }
    
    mutating private func matchCards(between chosenIndex: Int, and potentialMatchIndex: Int) {
        score += 2
        cards[chosenIndex].isMatched = true
        cards[potentialMatchIndex].isMatched = true
    }
    
    mutating private func penalizeMismatch(between chosenIndex: Int, and potentialMatchIndex: Int) {
        if cards[chosenIndex].flipCount > 1 || cards[potentialMatchIndex].flipCount > 1 {
            score -= 1
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
            return "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "") \n flip count: \(flipCount)"
        }
        
        var isFaceUp: Bool {
            get { return _isFaceUp }
            set { if newValue && !_isFaceUp { flipCount += 1 }; _isFaceUp = newValue }
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
