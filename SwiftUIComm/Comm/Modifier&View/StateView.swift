//
//  StateView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/16.
//

import SwiftUI

public enum StateType {
    case all
    case visitor
    case noNetwork
    case none
}

public extension View {
    /// 未登录时自动加载VisitorView, 无网络时自动加载NoNetworkView
    /// - Parameter type: 加载哪个
    /// - Returns: View
    func sl_state(_ type: StateType = .all) -> some View {
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

/// 未登录时自动加载VisitorView
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

/// 无网络时自动加载NoNetworkView
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
