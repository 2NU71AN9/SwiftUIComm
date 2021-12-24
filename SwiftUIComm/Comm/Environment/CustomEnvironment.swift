//
//  CustomEnvironment.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/24.
//

import SwiftUI
import SLIKit

struct ViewControllerHolder {
    var root: UIViewController?
}
struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder {
        ViewControllerHolder(root: SL.WINDOW?.rootViewController)
    }
}
extension EnvironmentValues {
    var rootVC: UIViewController? {
        self[ViewControllerKey.self].root
    }
}
