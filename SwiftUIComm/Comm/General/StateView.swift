//
//  StateView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/16.
//

import SwiftUI

struct StateVisitor: ViewModifier {
    @EnvironmentObject var shared: AccountServicer
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if shared.isLogin {
            content
        } else {
            VisitorView()
        }
    }
}

struct StateNoNetwork: ViewModifier {
    @EnvironmentObject var shared: AccountServicer
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if shared.networkStatus == .noNet {
            NoNetworkView()
        } else {
            content
        }
    }
}

public enum StateType {
    case all
    case visitor
    case noNetwork
    case none
}

public extension View {
    
    /// 自动加载VisitorView和NoNetworkView
    /// - Parameter type: 记载哪个
    /// - Returns: View
    func state(_ type: StateType = .all) -> some View {
        Group {
            switch type {
            case .all:
                self.modifier(StateVisitor()).modifier(StateNoNetwork())
            case .visitor:
                self.modifier(StateVisitor())
            case .noNetwork:
                self.modifier(StateNoNetwork())
            case .none:
                self
            }
        }
    }
}
