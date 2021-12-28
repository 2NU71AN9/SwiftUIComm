//
//  InteractiveDismiss.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/28.
//

import SwiftUI

final class SheetDelegate: NSObject, UIAdaptivePresentationControllerDelegate {
    var isDisable: Bool
    @Binding var attempToDismiss: UUID
    
    init(_ isDisable: Bool, attempToDismiss: Binding<UUID> = .constant(UUID())) {
        self.isDisable = isDisable
        _attempToDismiss = attempToDismiss
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        !isDisable
    }
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        attempToDismiss = UUID()
    }
}

struct SetSheetDelegate: UIViewRepresentable {
    let delegate: SheetDelegate
    
    init(isDisable: Bool, attempToDismiss: Binding<UUID>) {
        self.delegate = SheetDelegate(isDisable, attempToDismiss: attempToDismiss)
    }
    
    func makeUIView(context: Context) -> some UIView {
        UIView()
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            uiView.parentViewController?.presentationController?.delegate = delegate
        }
    }
}
