//
//  VisitorView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/15.
//

import SwiftUI

struct VisitorView: View {
    
    @EnvironmentObject var shared: AccountServicer
    
    var body: some View {
        VStack {
            Image("cry100")
            Text("您还未登录, 请先登录")
                .font(.subheadline)
                .padding()
            Button {
                shared.gotoLogin()
            } label: {
                Text("立即登录")
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
            }
        }
    }
}

struct VisitorView_Previews: PreviewProvider {
    static var previews: some View {
        VisitorView()
    }
}
