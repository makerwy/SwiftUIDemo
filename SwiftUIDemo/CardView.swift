//
//  CardView.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/5/24.
//

import SwiftUI

struct CardView: View {
    var card: GameCard<String>.Card
    
    var body: some View {
        ZStack(content: {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10).fill(Color.white)
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 3)
                Text(card.content)
            }else {
                RoundedRectangle(cornerRadius: 10).fill()
            }
        })
    }
}

struct Cardify: ViewModifier {
    var isFaceUp = false
    func body(content: Content) -> some View {
        ZStack(content: {
            if isFaceUp {
                RoundedRectangle(cornerRadius: 10).fill(Color.white)
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 3)
                content
            }else {
                RoundedRectangle(cornerRadius: 10).fill()
            }
        })
    }
}
