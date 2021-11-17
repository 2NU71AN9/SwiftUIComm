//
//  SecondView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/17.
//

import SwiftUI

struct SecondView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        Button("返回") {
            mode.wrappedValue.dismiss()
        }
        .navigationTitle("第二页")
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}
