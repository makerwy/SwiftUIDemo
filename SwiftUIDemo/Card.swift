//
//  Card.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/5/24.
//

import Foundation

struct GameCard<CardContent> {
    var cards: [Card]
    
    mutating func choose(card: GameCard<String>.Card) {
        let index = index(of: card)
        cards[index].isFaceUp = !cards[index].isFaceUp
        print("card choose: \(card)")
    }
    
    func index(of card: GameCard<String>.Card) -> Int {
        for (index, item) in cards.enumerated() {
            if item.id == card.id {
                return index
            }
        }
        return 0
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
    }
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
}
