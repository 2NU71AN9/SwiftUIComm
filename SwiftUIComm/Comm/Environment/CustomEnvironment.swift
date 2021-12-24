//
//  CustomEnvironment.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/24.
//

import SwiftUI
import SLIKit

extension EnvironmentValues {
    var rootVC: UIViewController? {
        self[ViewControllerKey.self].root
    }
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}


struct ViewControllerHolder {
    var root: UIViewController?
}

private struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder {
        ViewControllerHolder(root: SL.WINDOW?.rootViewController)
    }
}



private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}
