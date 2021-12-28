//
//  DisableSheetView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/28.
//

import SwiftUI

struct DisableSheetView: View {
    
    @State private var disable = true
    @State private var attempToDismiss = UUID()
    
    var body: some View {
        if #available(iOS 15.0, *) {
            Button("不可以返回: \(disable)") {
                disable.toggle()
            }
            .interactiveDismissDisabled(disable, attempToDismiss: $attempToDismiss)
            .onChange(of: attempToDismiss) { _ in
                print("Dismiss")
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

struct DisableSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DisableSheetView()
    }
}

