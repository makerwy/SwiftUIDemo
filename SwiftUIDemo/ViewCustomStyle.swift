//
//  ViewCustomStyle.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/9.
//

import SwiftUI

public enum TripleState: Int {
    case low
    case med
    case high
}
struct Example4: View {
    @State var state: TripleState = .low

    var stateDesc: String {
        get {
            switch self.state {
            case .low:
                return "低"
            case .med:
                return "中"
            case .high:
                return "高"
            }
        }
    }
    var body: some View {
        VStack {
            TripleToggle(label: Text(self.stateDesc), tripleState: $state)

            TripleToggle(label: Text(self.stateDesc), tripleState: $state)
                .tripleToggleStyle(KnobTripleToggleStyle(dotColor: .red))

            TripleToggle(label: Text(self.stateDesc), tripleState: $state)
                .tripleToggleStyle(KnobTripleToggleStyle(dotColor: .black))

            TripleToggle(label: Text(self.stateDesc), tripleState: $state)
                .frame(width: 300, height: 200)
                .tripleToggleStyle(DashBoardTripleToggleStyle())
        }
            .tripleToggleStyle(DefaultTripleToggleStyle())
    }
}

protocol TripleToggleStyle {
    associatedtype Body: View
    func makeBody(configuration: Self.Configuration) -> Self.Body
    typealias Configuration = TripleToggleStyleConfiguration
}

extension TripleToggleStyle {
    func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
        AnyView(self.makeBody(configuration: configuration))
    }
}

public struct TripleToggleStyleConfiguration {
    @Binding var tripleState: TripleState
    var label: Text
}

extension View {
    func tripleToggleStyle<S>(_ style: S) -> some View where S: TripleToggleStyle {
        self.environment(\.tripleToggleStyle, AnyTripleToggleStyle(style))
    }
}

public struct AnyTripleToggleStyle: TripleToggleStyle {
    private let _makeBody: (TripleToggleStyleConfiguration) -> AnyView

    init<ST: TripleToggleStyle>(_ style: ST) {
        self._makeBody = style.makeBodyTypeErased
    }

    func makeBody(configuration: Configuration) -> some View {
        return self._makeBody(configuration)
    }
}
extension EnvironmentValues {
    var tripleToggleStyle: AnyTripleToggleStyle {
        get {
            self[TripleToggleKey.self]
        }
        set {
            self[TripleToggleKey.self] = newValue
        }
    }
}

public struct TripleToggleKey: EnvironmentKey {
    public static var defaultValue: AnyTripleToggleStyle = AnyTripleToggleStyle(DefaultTripleToggleStyle())
}

public struct TripleToggle: View {
    @Environment(\.tripleToggleStyle) var style: AnyTripleToggleStyle

    let label: Text
    @Binding var tripleState: TripleState

    public var body: some View {
        let config = TripleToggleStyleConfiguration(tripleState: self.$tripleState, label: self.label)
        return style.makeBody(configuration: config)
    }
}

public struct DefaultTripleToggleStyle: TripleToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        DefaultTripleToggle(state: configuration.$tripleState, label: configuration.label)
    }

    struct DefaultTripleToggle: View {
        let width: CGFloat = 60

        @Binding var state: TripleState
        var label: Text

        var stateAlignment: Alignment {
            switch self.state {
            case .low:
                return .leading
            case .med:
                return .center
            case .high:
                return .trailing
            }
        }

        var stateColor: Color {
            switch self.state {
            case .low:
                return .green
            case .med:
                return .yellow
            case .high:
                return .red
            }
        }

        var body: some View {
            VStack(spacing: 10) {
                label
                ZStack(alignment: self.stateAlignment) {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: self.width, height: self.width / 2.0)
                        .foregroundColor(self.stateColor)

                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: self.width / 2 - 4, height: self.width / 2 - 6)
                        .padding(4)
                        .foregroundColor(.white)
                        .onTapGesture {
                            withAnimation {
                                switch self.state {
                                case .low:
                                    self.$state.wrappedValue = .med
                                case .med:
                                    self.$state.wrappedValue = .high
                                case .high:
                                    self.$state.wrappedValue = .low
                                }
                            }
                    }
                }
            }
        }
    }
}

public struct KnobTripleToggleStyle: TripleToggleStyle {
    let dotColor: Color

    func makeBody(configuration: Self.Configuration) -> KnobTripleToggleStyle.KnobTripleToggle {
        KnobTripleToggle(dotColor: dotColor, state: configuration.$tripleState, label: configuration.label)
    }

    public struct KnobTripleToggle: View {
        let dotColor: Color
        @Binding var state: TripleState
        var label: Text
        var angle: Angle {
                switch self.state {
                case .low: return Angle(degrees: -30)
                case .med: return Angle(degrees: 0)
                case .high: return Angle(degrees: 30)
            }
        }
        public var body: some View {
            let g = Gradient(colors: [.white, .gray, .white, .gray, .white, .gray, .white])
            let knobGradient = AngularGradient(gradient: g, center: .center)
            return VStack(spacing: 10) {
                label
                ZStack {
                    Circle()
                        .fill(knobGradient)
                    DotShape()
                        .fill(self.dotColor)
                        .rotationEffect(self.angle)
                }
                .frame(width: 150, height: 150)
                .onTapGesture {
                    withAnimation {
                        switch self.state {
                        case .low:
                            self.$state.wrappedValue = .med
                        case .med:
                            self.$state.wrappedValue = .high
                        case .high:
                            self.$state.wrappedValue = .low
                        }
                    }
                }
            }
        }
    }

    struct DotShape: Shape {
        func path(in rect: CGRect) -> Path {
            return Path(ellipseIn: CGRect(x: rect.width / 2 - 8, y: 8, width: 16, height: 16))
        }
    }
}

struct DashBoardTripleToggleStyle: TripleToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        DashBoardTripleToggle(state: configuration.$tripleState, label: configuration.label)
    }

    struct DashBoardTripleToggle: View {
        @Binding var state: TripleState
        var label: Text

        var angle: Double {
            switch self.state {
            case .low:
                return -30
            case .med:
                return 0
            case .high:
                return 30
            }
        }

        var body: some View {
            VStack {
                label

                ZStack {
                    DashBoardShape(angle: self.angle)
                        .stroke(Color.green, lineWidth: 3)
                }
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.green, lineWidth: 3))
            }
        }

        struct DashBoardShape: Shape {
            var angle: Double

            var animatableData: Double {
                get {
                    angle
                }
                set {
                    angle = newValue
                }
            }

            func path(in rect: CGRect) -> Path {
                var path = Path()

                let l = Double(rect.height * 0.8)
                let r = Angle(degrees: angle).radians
                let x = Double(rect.midX) + l * sin(r)
                let y = Double(rect.height) - l * cos(r)

                path.move(to: .init(x: rect.midX, y: rect.maxY))
                path.addLine(to: .init(x: x, y: y))

                return path
            }
        }
    }
}


struct Example4_Previews: PreviewProvider {
    static var previews: some View {
        Example4()
            .previewDevice("iPhone 11")
    }
}
