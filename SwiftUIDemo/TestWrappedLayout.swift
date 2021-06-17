//
//  TestWrappedLayout.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/8.
//

import SwiftUI

struct TestWrappedLayout: View {
    let w: CGFloat
    var texts: [String]

    var body: some View {
        self.generateContent(in: w)
    }

    private func generateContent(in w: CGFloat) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.texts, id: \.self) { t in
                self.item(for: t)
                    .padding([.trailing, .bottom], 4)
                    .alignmentGuide(.leading, computeValue: { d in

                        if (abs(width - d.width) > w)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if t == self.texts.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if t == self.texts.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }

    func item(for text: String) -> some View {
        Text(text)
            .padding([.leading, .trailing], 8)
            .frame(height: 30)
            .font(.subheadline)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(15)
            .onTapGesture {
                print("你好啊")
        }
    }
}

struct TestWrappedLayout_Previews: PreviewProvider {
    static var previews: some View {
        TestWrappedLayout(w: 200, texts: ["张三","王五","张三1","王五2","王五3","张三4","王五5","王五6","张三7","王五8"])
    }
}
