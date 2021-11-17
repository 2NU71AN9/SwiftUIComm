//
//  CustomModifier.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/17.
//

import SwiftUI

public extension View {
    /// 根据条件决定是否展示View
    /// - Parameter if: 条件
    /// - Returns: View
    func sl_if(_ if: Bool) -> some View {
        self.modifier(ShowIf(if: `if`))
    }
    
    /// 根据条件展示View
    /// - Parameter if: 条件
    /// - Parameter else: 条件为false展示的view
    /// - Returns: View
    func sl_if<T: View>(_ if: Bool, else: @escaping () -> T) -> some View {
        self.modifier(ShowIfWithElse(if: `if`, else: `else`))
    }
    
    /// 手动返回, 取消侧滑返回
    /// - Parameter backTitle: 返回title
    /// - Parameter action: 返回前的动作, 最后调pop(true)进行返回
    /// - Returns: View
    func sl_pop(_ backTitle: String? = "返回", _ action: @escaping ((Bool) -> ()) -> ()) -> some View {
        self.modifier(NaviPop(backTitle: backTitle, action: action))
    }
}

/// 根据条件决定是否展示View
struct ShowIf: ViewModifier {
    var `if`: Bool
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if `if` {
            content
        } else {
            EmptyView()
        }
    }
}

/// 根据条件展示View
struct ShowIfWithElse<T: View>: ViewModifier {
    var `if`: Bool
    var `else`: () -> T
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if `if` {
            content
        } else {
            `else`()
        }
    }
}


/// 手动返回
struct NaviPop: ViewModifier {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var backTitle: String?
    var action: ((Bool) -> ()) -> ()
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        action() { value in
                            if (value) { mode.wrappedValue.dismiss() }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .font(.headline)
                            Text(backTitle ?? "返回")
                        }
                    }
                }
            }
    }
}
