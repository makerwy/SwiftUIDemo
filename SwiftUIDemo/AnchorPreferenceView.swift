//
//  AnchorPreferenceView.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/15.
//

import SwiftUI

struct AnchorPreferenceView: View {
    @State private var titles = ["推荐", "要闻", "视频", "抗疫", "北京","新时代", "娱乐", "体育", "军事", "NBA","科技", "财经", "时尚"]
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(0..<titles.count) { index in
                    SegmentItem(title: titles[index],
                                 index: index,
                                 selectedIndex: selectedIndex)
                        .onTapGesture {
                            withAnimation {
                                self.selectedIndex = index
                            }
                        }
                }
            }
        }
        .backgroundPreferenceValue(MySegmentPreferenceKey.self) { preferences in
            GeometryReader { proxy in
                self.createBottomLine(proxy, preferences: preferences)
            }
        }
    }
    
    func createBottomLine(_ proxy: GeometryProxy, preferences: [MySegmentPreferenceData]) -> some View {
        let p = preferences.first(where: { $0.viewIdx == self.selectedIndex })
        let bounds = proxy[p!.bounds]
        return RoundedRectangle(cornerRadius: 2.5)
            .foregroundColor(.green)
            .frame(width: bounds.width, height: 5)
            .offset(x: bounds.minX, y: bounds.height - 5)
                /// 开启动画
//            .animation(.easeInOut)
    }
}

struct SegmentItem: View {
    let title: String
    let index: Int
    let selectedIndex: Int
    
    var body: some View {
            Text(title)
            .scaleEffect(index == self.selectedIndex ? 1.5 : 1.0)
            .font(.title)
            .foregroundColor(index == self.selectedIndex ? .primary : .secondary)
            .padding(.all, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .anchorPreference(key: MySegmentPreferenceKey.self, value: .bounds) {
                [MySegmentPreferenceData(viewIdx: index, bounds: $0)]
            }
            .transformAnchorPreference(key: MySegmentPreferenceKey.self, value: .topLeading) { value, anchor in
                value[0].topLeading = anchor
            }
    }
}

struct MySegmentPreferenceData {
    let viewIdx: Int
    let bounds: Anchor<CGRect>
    var topLeading: Anchor<CGPoint>? = nil
}

struct MySegmentPreferenceKey: PreferenceKey {
    static var defaultValue: [MySegmentPreferenceData] = []
    static func reduce(value: inout [MySegmentPreferenceData], nextValue: () -> [MySegmentPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}


struct AnchorPreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        AnchorPreferenceView()
    }
}
