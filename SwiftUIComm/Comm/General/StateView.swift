//
//  StateView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/16.
//

import SwiftUI

// 遵守协议者必须添加环境变量 @EnvironmentObject var shared: AccountServicer
protocol StateView: View {
    
    associatedtype myBody: View
    
    @ViewBuilder var master: Self.myBody { get }
    var visitor: AnyView { get }
    var noNetwork: AnyView { get }
}

extension StateView {
    var body: some View {
        Group {
            if (AccountServicer.shared.networkStatus == SLNetworkStatus.noNet) {
                noNetwork
            } else if (AccountServicer.shared.isLogin) {
                master
            } else {
                visitor
            }
        }
    }
    var visitor: AnyView {
        AnyView(VisitorView())
    }
    var noNetwork: AnyView {
        AnyView(NoNetworkView())
    }
}
