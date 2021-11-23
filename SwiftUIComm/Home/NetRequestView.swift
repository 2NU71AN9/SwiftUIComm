//
//  NetRequestView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/19.
//

import SwiftUI
import Combine
import SLIKit

struct NetRequestView: View {
    
    @StateObject var viewModel = NetRequestViewModel()

    var body: some View {
        VStack {
            Text(viewModel.model.token ?? "").padding()
        }
    }
}

struct NetRequestView_Previews: PreviewProvider {
    static var previews: some View {
        NetRequestView()
    }
}

class NetRequestViewModel: ObservableObject {
    
    @Published var model = LoginModel()
    var cancellable: AnyCancellable?
    
    init() {
        loadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.model.token = "1111111"
        }
    }
    
    private func loadData() {
        cancellable = NetworkHandler.request(.login(account: "17615404066", password: "123456"))
            .mapModel(LoginModel.self)
            .sink(success: { model in
                self.model = model
            })
    }
}

struct LoginModel: Codable {
    var token: String?
    var id: String?
}
