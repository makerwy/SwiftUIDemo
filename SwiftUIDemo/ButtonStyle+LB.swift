//
//  ButtonStyle+LB.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/9.
//

import SwiftUI

struct MyButtonStyle: ButtonStyle {
    var color: Color = .red
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(15)
            .background(RoundedRectangle(cornerRadius: 5).fill(color))
            .compositingGroup()
            .shadow(color: .black, radius: 3)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
    }
}
