//
//  LoginView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/16.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var shared: AccountServicer
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        Button {
            shared.loginSuccess()
            mode.wrappedValue.dismiss()
        } label: {
            Text("点击进行登录")
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
