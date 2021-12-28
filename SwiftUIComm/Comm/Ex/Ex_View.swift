//
//  Ex_View.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/17.
//

import SwiftUI

public extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}

public extension View {
    func interactiveDismissDisabled(_ isDisable: Bool, attempToDismiss: Binding<UUID>) -> some View {
        background(SetSheetDelegate(isDisable: isDisable, attempToDismiss: attempToDismiss))
    }
}
