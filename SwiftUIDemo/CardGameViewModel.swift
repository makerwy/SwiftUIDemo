//
//  CardGameViewModel.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/5/24.
//

import Foundation

class CardGameViewModel: ObservableObject {
    @Published private(set) var model: GameCard<String> = CardGameViewModel.createGame()
    
    static func createGame() -> GameCard<String> {
        let emojis = ["😁","😢"]
        return GameCard(numberOfPairsOfCards: 2) { index in
            emojis[index]
        }
    }
    
    var cards: [GameCard<String>.Card] {
        model.cards
    }
    
    func choose(card: GameCard<String>.Card) {
        model.choose(card: card)
    }
    
    func index(of card: GameCard<String>.Card) -> Int {
        for (index, item) in model.cards.enumerated() {
            if item.id == card.id {
                return index
            }
        }
        return 0
    }
}
