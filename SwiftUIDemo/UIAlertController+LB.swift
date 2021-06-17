//
//  UIAlertController+LB.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/8.
//

//import SwiftUI

import UIKit

public typealias LBAlertActionHandler = () -> Void

public protocol LBAlertAction {
    var title: String { get }
    var style: UIAlertAction.Style { get }
    var action: LBAlertActionHandler { get }
}

public struct DefaultAction: LBAlertAction {
    public var title: String
    public var style: UIAlertAction.Style
    public var action: LBAlertActionHandler
    
    init(_ title: String, action: @escaping LBAlertActionHandler = {}) {
        self.title = title
        self.style = .default
        self.action = action
    }
}

public struct CancelAction: LBAlertAction {
    public var title: String
    public var style: UIAlertAction.Style
    public var action: LBAlertActionHandler
    
    init(_ title: String, action: @escaping LBAlertActionHandler = {}) {
        self.title = title
        self.style = .cancel
        self.action = action
    }
}

public struct DestructiveAction: LBAlertAction {
    public var title: String
    public var style: UIAlertAction.Style
    public var action: LBAlertActionHandler
    
    init(_ title: String, action: @escaping LBAlertActionHandler = {}) {
        self.title = title
        self.style = .destructive
        self.action = action
    }
}

@resultBuilder public struct LBAlertControllerBuilder {
    public static func buildBlock(_ components: LBAlertAction...) -> [UIAlertAction] {
        components.map { action in
            UIAlertAction(title: action.title, style: action.style) { _ in
                action.action()
            }
        }
    }
}

public extension UIAlertController {
    convenience init(title: String, message: String, style: UIAlertController.Style = .alert, @LBAlertControllerBuilder build: () -> [UIAlertAction]) {
        let actions = build()
        self.init(title: title, message: message, preferredStyle: style)
        actions.forEach { self.addAction($0) }
    }
}
