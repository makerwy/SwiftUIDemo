//
//  LoginView.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/17.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject private var viewModel = LoginViewModel()
    
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            VStack {
                TextField("请输入用户名", text: $viewModel.userName)
                    .frame(height: 35)
                
                if viewModel.showUserNameError {
                    Text("用户名不能少于3位！！！")
                        .foregroundColor(Color.red)
                }
                
                SecureField("请输入密码", text: $viewModel.password)
                    .frame(height: 35)
                
                if viewModel.showPasswordError {
                    Text("密码不能少于6位！！！")
                                        .foregroundColor(Color.red)
                }
                
                GeometryReader {proxy in
                    Button(action: {
                        self.showAlert.toggle()
                    }, label: {
                        Text("登录")
                            .foregroundColor(viewModel.buttonEnable ? Color.white : Color.white.opacity(0.3))
                            .frame(width: proxy.size.width, height: 35)
                            .background(viewModel.buttonEnable ? Color.blue : Color.gray)
                            .clipShape(Capsule())
                    })
                    .disabled(!viewModel.buttonEnable)
                }
                .frame(height: 35)
            }
            .padding()
            .border(Color.green)
            .padding()
            .animation(.easeInOut)
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("登录成功"), message: Text("\(viewModel.userName) \n \(viewModel.password)"), dismissButton: nil)
            })
            .onDisappear(perform: {
                viewModel.clear()
            })
            
            
//            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
