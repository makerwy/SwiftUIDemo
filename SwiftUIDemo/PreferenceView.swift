//
//  PreferenceView.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/11.
//

import SwiftUI

struct PreferenceView: View {
    @State private var activeNumber: Int = 1
    @State private var rects: [CGRect] = Array<CGRect>(repeating: CGRect(), count: 9)
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Circle()
                .stroke(Color.green, lineWidth: 5)
                .frame(width: rects[activeNumber - 1].width, height: rects[activeNumber - 1].height)
                .offset(x: rects[activeNumber - 1].minX, y: rects[activeNumber - 1].minY)
                .animation(.easeInOut)
            
            VStack {
                Spacer()
                HStack {
                    NumberPreferenceView(activeNumber: $activeNumber, number: 1)
                    NumberPreferenceView(activeNumber: $activeNumber, number: 2)
                    NumberPreferenceView(activeNumber: $activeNumber, number: 3)
                }
                HStack {
                    NumberPreferenceView(activeNumber: $activeNumber, number: 4)
                    NumberPreferenceView(activeNumber: $activeNumber, number: 5)
                    NumberPreferenceView(activeNumber: $activeNumber, number: 6)
                }
                HStack {
                    NumberPreferenceView(activeNumber: $activeNumber, number: 7)
                    NumberPreferenceView(activeNumber: $activeNumber, number: 8)
                    NumberPreferenceView(activeNumber: $activeNumber, number: 9)
                }
                Spacer()
            }
        }
        .onPreferenceChange(NumberPreferenceKey.self) { preferences in
            for pre in preferences {
                self.rects[pre.viewIdx] = pre.rect
            }
        }
        .coordinateSpace(name: "ZStackSpace")
    }
}

struct NumberPreferenceView: View {
    @Binding var activeNumber: Int
    let number: Int
    var body: some View {
        Text("\(number)")
            .font(.system(size: 40, weight: .heavy, design: .rounded))
            .padding(20)
//            .background(NumberBorder(show: number == activeNumber))
            .background(NumberPreferenceViewSetter(idx: number - 1))
            .onTapGesture {
                self.activeNumber = number
            }
    }
}

struct NumberBorder: View {
    let show: Bool
    var body: some View {
        Circle()
            .stroke(show ? Color.green : Color.clear, lineWidth: 5)
            .animation(.easeInOut)
    }
}

struct NumberPreferenceViewSetter: View {
    let idx: Int
    var body: some View {
        GeometryReader {proxy in
            Circle()
                .stroke(Color.clear, lineWidth: 5)
                .preference(key: NumberPreferenceKey.self, value: [NumberPreferenceValue(rect: proxy.frame(in: .named("ZStackSpace")), viewIdx: idx)])
        }
    }
}

struct NumberPreferenceKey: PreferenceKey {
    static var defaultValue: [NumberPreferenceValue] = []
    
    static func reduce(value: inout [NumberPreferenceValue], nextValue: () -> [NumberPreferenceValue]) {
        value.append(contentsOf: nextValue())
    }
}

struct NumberPreferenceValue: Equatable {
    let rect: CGRect
    let viewIdx: Int
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
    }
}
