//
//  PreferenceDemoView.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/15.
//

import SwiftUI

struct PreferenceDemoView: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color.gray.opacity(0.5))
                .frame(width: 250, height: 300)
                .anchorPreference(key: MyDemoPreferenceKey.self, value: .bounds) { anchor in
                    [MyDemoPreferenceData(viewType: .miniMapArea, bounds: anchor)]
                }
            ZStack(alignment: .topLeading) {
                VStack {
                    HStack {
                        DragableView(color: .green)
                        DragableView(color: .blue)
                        DragableView(color: .pink)
                    }
                    HStack {
                        DragableView(color: .black)
                        DragableView(color: .white)
                        DragableView(color: .purple)
                    }
                }
            }
            .frame(width: 550, height: 300)
            .background(Color.orange.opacity(0.5))
            .transformAnchorPreference(key: MyDemoPreferenceKey.self, value: .bounds) { value, anchor in
                value.append(contentsOf: [MyDemoPreferenceData(viewType: .parent, bounds: anchor)])
            }
        }
        .overlayPreferenceValue(MyDemoPreferenceKey.self) { value in
            GeometryReader { proxy in
                MiniMap(geometry: proxy, preferences: value)
            }
        }
    }
}

struct DragableView: View {
    let color: Color
    
    @State var currentOffset: CGSize = CGSize.zero
    @State var preOffset: CGSize = CGSize(width: 100, height: 100)
    
    var w: CGFloat {
        currentOffset.width + preOffset.width
    }
    
    var h: CGFloat {
        currentOffset.height + preOffset.height
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .foregroundColor(color)
            .frame(width: w, height: h)
            .anchorPreference(key: MyDemoPreferenceKey.self, value: .bounds) { anchor in
                [MyDemoPreferenceData(viewType: .son(color), bounds: anchor)]
            }
            .gesture(DragGesture().onChanged({ value in
                self.currentOffset = value.translation
            })
                        .onEnded({ _ in
                self.preOffset = CGSize(width: w, height: h)
                self.currentOffset = .zero
            }))
    }
}

struct MiniMap: View {
    
    let geometry: GeometryProxy
    let preferences: [MyDemoPreferenceData]
    
    var body: some View {
        guard let parentAnchor = preferences.first(where: {$0.viewType == .parent})?.bounds else { return AnyView(EmptyView()) }
        guard let miniMapAreaAnchor = preferences.first(where: {$0.viewType == .miniMapArea})?.bounds else { return AnyView(EmptyView()) }
        let factory = geometry[parentAnchor].width / (geometry[miniMapAreaAnchor].width - 10)
        let miniMapAreaPosition = CGPoint(x: geometry[miniMapAreaAnchor].minX, y: geometry[miniMapAreaAnchor].minY)
        let parentPosition = CGPoint(x: geometry[parentAnchor].minX, y: geometry[parentAnchor].minY)
        return AnyView(minieMapView(factory, miniMapAreaPosition, parentPosition))
    }
    
    func minieMapView(_ factory: CGFloat, _ miniMapAreaPosition: CGPoint, _ parentPosition: CGPoint) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(preferences.reversed()) { pref in
                if pref.show() {
                    self.rectangleView(pref, factory, miniMapAreaPosition, parentPosition)
                }
            }
        }
    }
    
    func rectangleView(_ pref: MyDemoPreferenceData, _ factory: CGFloat, _ miniMapArearPosition: CGPoint, _ parentPosition: CGPoint) -> some View {
        return Rectangle()
            .fill(pref.getColor())
            .frame(width: geometry[pref.bounds].width / factory, height: geometry[pref.bounds].height / factory)
            .offset(x: ((geometry[pref.bounds].minX - parentPosition.x) / factory + miniMapArearPosition.x),
                    y: ((geometry[pref.bounds].minY - parentPosition.y) / factory + miniMapArearPosition.y))
    }
}


struct MyDemoPreferenceData: Identifiable {
    let id = UUID()
    let viewType: ViewType
    let bounds: Anchor<CGRect>
    
    func getColor() -> Color {
        switch viewType {
        case .parent:
            return Color.orange.opacity(0.5)
        case .son(let color):
            return color
        case .miniMapArea:
            return Color.gray.opacity(0.3)
        }
    }
    
    func show() -> Bool {
        switch viewType {
        case .parent:
            return true
        case .son:
            return true
        case .miniMapArea:
            return false
        }
    }
}

struct MyDemoPreferenceKey: PreferenceKey {
    static var defaultValue: [MyDemoPreferenceData] = []
    static func reduce(value: inout [MyDemoPreferenceData], nextValue: () -> [MyDemoPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

enum ViewType: Equatable {
    case parent
    case son(Color)
    case miniMapArea
}

struct PreferenceDemoView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceDemoView()
    }
}
