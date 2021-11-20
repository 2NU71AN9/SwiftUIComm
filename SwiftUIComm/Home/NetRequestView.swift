//
//  NetRequestView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/19.
//

import SwiftUI
import Combine

struct NetRequestView: View {
    
    @State var cancellable: AnyCancellable?
    
    var body: some View {
        Button("点击", action: loadData)
            .navigationTitle("网络请求")
    }
    
    private func loadData() {
        cancellable = NetworkHandler.request(.login(account: "17615404066", password: "123456"))
            .sink { component in
                switch component {
                case .finished:
                    print("完成")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { nr in
                print(nr)
            }
    }
}

struct NetRequestView_Previews: PreviewProvider {
    static var previews: some View {
        NetRequestView()
    }
}
