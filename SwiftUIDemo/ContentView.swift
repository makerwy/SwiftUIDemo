//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/5/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject var viewModel = CardGameViewModel()
    
    @State var index: Int = -1
    @State var date: Date = Date()
    @State var value: CGFloat = 0
    @State var step: Int = 0
    
    @State var isShow: Bool = false
    
    
    let helloPublisher = "Hello Combine".publisher
    let fibonacciPublisher = [0,1,1,2,3,5].publisher
    let dictPublisher = [1:"Hello",2:"World"].publisher
    
    
    let passthroughObject = PassthroughSubject<String, Error>()
    let img = ["bg", "bg", "bg", "bg", "bg"]
    
    func rotateAngle(_ proxy: GeometryProxy) -> Angle {
        let dif = 600 * 0.5 - proxy.frame(in: .named("ScrollViewSpace")).midX
        let pct = min(dif / proxy.size.width * 0.5, 1)
        return .degrees(Double(30 * pct))
    }
    
    var body: some View {

        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(0..<img.count) { index in
                    GeometryReader { proxy in
                        Image(img[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .rotation3DEffect(self.rotateAngle(proxy), axis: (x: 0, y: 11, z: 0))
                    }
                    .background(Color.red)
                    .frame(width: 600.0 / 3, height: 600.0 / 3 * (425 / 640))
                }
            }
        }
        .frame(width: 600)
        .coordinateSpace(name: "ScrollViewSpace")
        
            
//        ScrollView(.horizontal) {
//            if #available(iOS 14.0, *) {
//                ScrollViewReader { scrollViewProxy in
//
//                    LazyHStack(spacing: 10) {
//                        ForEach(0..<20) { index in
//                            Text("\(index)")
//                                .frame(width: 100, height: 240)
//
//                                .background(index == 6 ? Color.green : Color.orange.opacity(0.5))
//                                .cornerRadius(3.0)
//                        }
//                    }
//                    .padding(.horizontal, 10)
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//        .frame(height: 300, alignment:  .center)
//        Button(action: {
//            print("button pressed!")
//        }, label: {
//            Text("Tap Me1!")
//        })
//        Button("Tap Me!") {
//            print("button pressed!")
//        }.buttonStyle(MyButtonStyle(color: .blue))
        
        
//        Text("Hello, World!")
//                    .frame(width: 200, height: 100)
//                    .background(Color.green)
//                    .frame(width: 400, height: 200)
//                    .background(Color.orange.opacity(0.5))
        
//        Text("这个文本还挺长的，到达了一定字数后，就超过了一行的显示范围了！！！")
//                    .border(Color.blue)
//                    .frame(width: 200, height: 100)
//                    .border(Color.green)
//                    .font(.title)
        
//        TabView(selection: $index,
//                content:  {
//                    Text("首页ads").tabItem { Text("首页") }.tag(1)
//                    Text("仓储/物流das").tabItem { Text("仓储/物流") }.tag(2)
//                    Text("贸易das").tabItem { Text("贸易") }.tag(3)
//                    Text("我的dada").tabItem { Text("我的") }.tag(4)
//                })
        
        
        
//        VStack {
//            Text("ActionSheet")
//                .onTapGesture {
////                    isShow.toggle()
////
////                    let subscriber = fibonacciPublisher.sink { completion in
////                        switch completion {
////                        case .finished:
////                            print("finished")
////                        case .failure(let never):
////                            print(never)
////                        }
////                    } receiveValue: { value in
////                        print(value)
////                    }
//                    let alert = UIAlertController(title: "Delete all data?", message: "All your data will be deleted!") {
//                        DestructiveAction("Show More Options") {
//                            print("Deleting all data")
//                        }
//                        DefaultAction("Yes, Delete it All") {
//                            print("showing more options")
//                        }
//                        CancelAction("No, Don't Delete Anything")
//                    }
//
//
//                }
//                .popover(isPresented: $isShow, content: {
//                    Text("popover")
//                })
//            .actionSheet(isPresented: $isShow, content: {
                
//                let alert = UIAlertController(title: "Delete all data?", message: "All your data will be deleted!") {
//                    DestructiveAction("Show More Options") {
//                        print("Deleting all data")
//                    }
//                    DefaultAction("Yes, Delete it All") {
//                        print("showing more options")
//                    }
//                    CancelAction("No, Don't Delete Anything")
//                }
                
                
//                ActionSheet(title: Text(""),
//                            buttons:
//                    [.default(Text("Default"), action: {
//                        print("Default")
////                        self.isShow = false
//                    }),.destructive(Text("destructive"), action: {
//                        print("destructive")
////                        self.isShow = false
//                    }),.cancel({
//                        print("Cancel")
////                        self.isShow = false
//                    })])
//            })
//        }
        
//        VStack {
//            Picker(selection: $index, label: Text("Picker")) {
//                ForEach(0..<10) {item in
//                    Text("\(item)")
//                }
//            }
//            DatePicker(selection: $date) {
//                Text("date picker")
//            }
//            Slider(value: $value)
//            Stepper(value: $step, step: 1) { result in
//
//            } label: {
//                Text("Stepper \(step)")
//            }
//
//        }
        
        
//        HStack(content: {
//            ForEach(viewModel.cards) { card in
//                CardView(card: card).onTapGesture(perform: {
//                    self.viewModel.choose(card: card)
//                })
//            }
//        })
//        .padding()
//        .foregroundColor(Color.orange)
//        .font(.largeTitle)
    }
    
    
    func requestImageInfo() {
        if #available(iOS 15.0, *) {
//            async {
//                _ = await request()
//            }
            
//            async(priority: .default) {
//                //
//            }
        } else {
            // Fallback on earlier versions
        }
    }
    func request() {
        
    }
}
 

struct ExampleView: View {
    @State private var width: CGFloat = 50

    var body: some View {
        VStack {
            SubView()
                .frame(width: self.width, height: 120)
                .border(Color.blue, width: 2)

            Text("Offered Width \(Int(width))")
            Slider(value: $width, in: 0...200, step: 1)
        }
    }
    
}

struct SubView: View {
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(Color.yellow.opacity(0.7))
                .frame(width: max(proxy.size.width, 120), height: max(proxy.size.height, 120))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
