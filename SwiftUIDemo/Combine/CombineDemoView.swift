//
//  CombineDemoView.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/16.
//

import SwiftUI
import Combine

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
                        showLogin.toggle()
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
