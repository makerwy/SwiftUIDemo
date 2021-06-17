//
//  TogleStyle.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/9.
//

import SwiftUI

struct Example2: View {
    @State private var flag = false
    @State private var flipped = false

    var body: some View {
        VStack {
            Toggle(isOn: $flag) {
                VStack {
                    Group {
                        Image(systemName: flipped ? "folder.fill" : "map.fill")
                        Text(flipped ? "地图" : "列表")
                            .font(.caption)
                    }
                    .rotation3DEffect(flipped ? .degrees(180) : .degrees(0), axis: (x: 0, y: 1, z: 0))
                }
            }
        }
        .toggleStyle(MyToggleStyle2(flipped: $flipped))
    }
}

struct MyToggleStyle2: ToggleStyle {
    let width: CGFloat = 50
    let height: CGFloat = 60

    @Binding var flipped: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height)
            .modifier(FlipEffect(flipped: $flipped, angle: configuration.isOn ? 180 : 0))
            .onTapGesture {
                withAnimation {
                    configuration.$isOn.wrappedValue.toggle()
                }
            }
    }
}

struct FlipEffect: GeometryEffect {
    @Binding var flipped: Bool
    var angle: Double

    var animatableData: Double {
        get {
            angle
        }
        set {
            angle = newValue
        }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        DispatchQueue.main.async {
            self.flipped = (self.angle >= 90 && self.angle <= 180)
        }

        let a = CGFloat(Angle.degrees(angle).radians)

        var  transform3d = CATransform3DIdentity
        transform3d.m34 = -1/max(size.width, size.height)
        transform3d = CATransform3DRotate(transform3d, a, 0, 1, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height/2.0))

        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}

struct Example2_Previews: PreviewProvider {
    static var previews: some View {
        Example2()
            .previewDevice("iPhone 11")
    }
}
