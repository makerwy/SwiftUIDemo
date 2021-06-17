//
//  Gradient.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/9.
//

import SwiftUI

struct GradientView: View {
    var body: some View {
//        VStack {
//            ///LinearGradient 线性渐变
//            RoundedRectangle(cornerRadius: 10)
//                .fill(LinearGradient(gradient: Gradient(colors: [.green, .orange, .blue]),
//                                     startPoint: .leading,
//                                     endPoint: .trailing))
//            Text("LinearGradient")
//        }
//        VStack {
//            ///RadialGradient 径向渐变
//            RoundedRectangle(cornerRadius: 10)
//                .fill(RadialGradient(gradient: Gradient(colors: [.green, .orange, .blue]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, startRadius: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/, endRadius: 200))
//            Text("RadialGradient")
//        }
        
//        VStack {
//            ///AngularGradient 角度渐变
//            RoundedRectangle(cornerRadius: 10)
//                .fill(AngularGradient(gradient: Gradient(colors: [.green, .orange, .blue]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, startAngle: /*@START_MENU_TOKEN@*/.zero/*@END_MENU_TOKEN@*/, endAngle: .degrees(360)))
//            Text("AngularGradient")
//        }
        
        Circle()
            .stroke(Color.orange, lineWidth: 20)
            .padding(50)
        
    }
}


struct GradientView_Previews: PreviewProvider {
    static var previews: some View {
        GradientView()
    }
}
