//
//  ActivityIndicator.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/17.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
    
}

