//
//  PreferenceTreeDemoView.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/15.
//

import SwiftUI

struct PreferenceTreeDemoView: View {
    
    @State private var binarytree = Tree<Int>(10, children: [
        Tree<Int>(20, children: [
            Tree<Int>(21),
            Tree<Int>(22)
        ]),
        Tree<Int>(30, children: [
            Tree<Int>(31),
            Tree<Int>(32)
        ])
    ])
    
    var body: some View {
        VStack {
            Diagram(tree: binarytree) { value in
                Text("\(value)")
                    .padding(5)
                    .background(Circle().foregroundColor(.yellow))
    //                .modifier()
            }
            
            Button("随机插入") {
                withAnimation {
                    self.binarytree.insert(Int.random(in: 0...100))
                }
            }
        }
    }
}

struct Diagram<A, V: View>: View {
    let tree: Tree<A>
    let node: (A) -> V

    typealias Key = CollectDict<String, Anchor<CGPoint>>

    var body: some View {
        VStack(spacing: 10) {
            node(tree.value)
                .anchorPreference(key: Key.self, value: .center, transform: {
                    [self.tree.id: $0]
                })

            HStack(alignment: .bottom, spacing: 10) {
                ForEach(tree.children) { child in
                    Diagram(tree: child, node: self.node)
                }
            }
        }
        .backgroundPreferenceValue(Key.self) { (centers: [String: Anchor<CGPoint>]) in
            GeometryReader { proxy in
                ForEach(self.tree.children) { child in
                    
                    Line(from: proxy[centers[self.tree.id]!],
                         to: proxy[centers[child.id]!])
                        .stroke()
                }
            }
        }
    }
}

struct Line: Shape {
    var from: CGPoint
    var to: CGPoint

    var animatableData: AnimatablePair<CGPoint, CGPoint> {
        get {
            AnimatablePair(from, to)
        }
        set {
            from = newValue.first
            to = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: from)
        path.addLine(to: to)

        return path
    }
}

extension CGPoint: VectorArithmetic {
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public mutating func scale(by rhs: Double) {
        x *= CGFloat(rhs)
        y *= CGFloat(rhs)
    }

    public var magnitudeSquared: Double {
        0
    }

    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

struct DiagramSample<E, V: View>: View {
    let tree: Tree<E>
    let node: (E) -> V
    
    var body: some View {
        VStack(spacing: 10) {
            node(tree.value)
            HStack(alignment: .bottom, spacing: 10) {
                ForEach(tree.children) {
                    child in
                    DiagramSample(tree: child, node: self.node)
                }
            }
        }
    }
}

struct Tree<T>: Identifiable {
    var id = UUID().uuidString
    var value: T
    var children: [Tree<T>] = []
    
    init(_ value: T, children: [Tree<T>] = []) {
        self.value = value
        self.children = children
    }
}

extension Tree where T == Int {
    mutating func insert(_ number: Int) {
        if number < value {
            if  children.count > 0 {
                children[0].insert(number)
            }else {
                children.append(Tree(number))
            }
        }else {
            if children.count == 2 {
                children[1].insert(number)
            }else if children.count == 1, children[0].value > number {
                children[0].insert(number)
            }else {
                children.append(Tree(number))
            }
        }
    }
}

struct CollectDict<Key: Hashable, Value>: PreferenceKey {
    static var defaultValue: [Key: Value] { [:] }
    static func reduce(value: inout [Key: Value], nextValue: () -> [Key: Value]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct PreferenceTreeDemoView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceTreeDemoView()
    }
}
