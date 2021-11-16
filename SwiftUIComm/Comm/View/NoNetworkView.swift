//
//  NoNetworkView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/15.
//

import SwiftUI

struct NoNetworkView: View {
    var body: some View {
        VStack {
            Image("cry100")
            Text("您的网络好像出了点问题\n请前往 设置-无线局域网/蜂窝网络 \n检查网络是否开启或者检查是否授予APP网络使用权限")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding()
            Button {
                if let url = URL(string: "App-Prefs:root") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } label: {
                Text("前往设置")
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
            }
        }
    }
}

struct NoNetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NoNetworkView()
    }
}
