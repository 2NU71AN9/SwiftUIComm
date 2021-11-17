//
//  CustomView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/17.
//

import SwiftUI

/// 根据条件显示不同View
public struct SL_IfStack<T: View, Y: View>: View {
    let `if`: Bool
    var view: () -> T
    var `else`: () -> Y
    
    /// 根据条件显示不同View
    /// - Parameters:
    ///   - if: 条件
    ///   - view: 条件为true显示
    ///   - else: 条件为false显示
    public init(_ if: Bool, @ViewBuilder view: @escaping () -> T, @ViewBuilder else: @escaping () -> Y) {
        self.`if` = `if`
        self.view = view
        self.`else` = `else`
    }
    
    @ViewBuilder
    public var body: some View {
        if `if` {
            view()
        } else {
            `else`()
        }
    }
}
