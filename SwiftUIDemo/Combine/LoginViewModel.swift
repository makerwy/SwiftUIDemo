//
//  LoginViewModel.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/17.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var buttonEnable: Bool = false
    
    @Published var showUserNameError = false
    @Published var showPasswordError = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private var userNamePublisher: AnyPublisher<String, Never> {
        return $userName.receive(on: RunLoop.main)
            .map { value in
                guard value.count > 2 else {
                    self.showUserNameError = value.count > 0
                    return value
                }
                self.showUserNameError = false
                return value
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordPublisher: AnyPublisher<String, Never> {
        return $password.receive(on: RunLoop.main)
            .map { value in
                guard value.count > 5 else {
                    self.showPasswordError = value.count > 0
                    return ""
                }
                self.showPasswordError = false
                return value
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        Publishers
            .CombineLatest(userNamePublisher, passwordPublisher)
            .map { v1, v2 in
                !v1.isEmpty && !v2.isEmpty
            }
            .receive(on: RunLoop.main)
            .assign(to: \.buttonEnable, on: self)
            .store(in: &cancellables)
    }
    
    func clear() {
        cancellables.removeAll()
    }
}
