//
//  CombineDemoView.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/16.
//

import SwiftUI
import Combine

enum MyError: Error {
    case unknow
    case other
}

///网络搜索
struct CombineDemoView: View {
    
    @ObservedObject private var viewModel = MyViewModel()
    @State private var showLogin = false
    
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Group {
                        if viewModel.loading {
                            ActivityIndicator()
                        }else {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                    .frame(width: 30, height: 30)
                    TextField("请输入要搜索的repository", text: $viewModel.inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("登录") {
//                        showLogin.toggle()
                        createAnyPublisher()
                    }
                }
                .padding(.horizontal,15)
            }
            .frame(height: 44)
            .background(Color.yellow)
            
            List(viewModel.repositories) { res in
                GithubListCell(repository: res)
            }
        }
        .sheet(isPresented: $showLogin, content: {
            LoginView()
        })
        .onDisappear {
            createAnyPublisher()
        }
    }
    
    func createAnyPublisher() {
        let publisher = AnyPublisher<String, MyError>.create { subscriber in
            // Values
            subscriber.send("Hello")
            subscriber.send("World!")

            // Complete with error
              subscriber.send(completion: .failure(MyError.other))

            // Or, complete successfully
            subscriber.send(completion: .finished)

            return AnyCancellable {
              // Perform cleanup
            }
          }
        .sink { _ in
            
        } receiveValue: { value in
            print(value)
        }

    }
    
}
struct GithubListCell: View {
    let repository: GithubRepository
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(repository.full_name)
                .font(.title3)
            
            Text(repository.description ?? "")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Image(systemName: "star")
                        .foregroundColor(.secondary)
                    
                    Text("\(repository.stargazers_count)")
                        .foregroundColor(.secondary)
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Circle()
                        .foregroundColor(Color.orange)
                        .frame(width: 10, height: 10)
                    
                    Text("\(repository.language)")
                        .foregroundColor(.secondary)
                }
            }
            .font(.caption)
        }
    }
}

struct CombineDemoView_Previews: PreviewProvider {
    static var previews: some View {
        CombineDemoView()
    }
}
