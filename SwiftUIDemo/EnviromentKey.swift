//
//  EnviromentKey.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/15.
//

import SwiftUI

struct EnviromentKeyView: View {
    @Environment(\.myEnviromentTestValue) var value: Double
    
    var body: some View {
        Text("\(value)")
    }
}

struct EnviromentKeyView_Previews: PreviewProvider {
    static var previews: some View {
        EnviromentKeyView().environment(\.myEnviromentTestValue, 20)
    }
}

struct MyEnviromentKey: EnvironmentKey {
    static var defaultValue: Double = 0.0
}

extension EnvironmentValues {
    var myEnviromentTestValue: Double {
        get {
            self[MyEnviromentKey.self]
        }
        set {
            self[MyEnviromentKey.self] = newValue
        }
    }
}
