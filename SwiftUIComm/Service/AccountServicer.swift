//
//  AccountServicer.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/16.
//

import SwiftUI

class AccountServicer: ObservableObject {
    
    static let shared: AccountServicer = {
        let shared = AccountServicer()
        SLNetworkListenManager.shared.listen()
        _ = SLNetworkListenManager.shared.networkChangedSubject.subscribe(onNext: { (value) in
            shared.networkStatus = value
        })
        return shared
    }()
    
    @Published private(set) var isLogin = false
    @Published private(set) var networkStatus: SLNetworkStatus = .noNet
    @Published var needLogin = false
}

extension AccountServicer {
    func gotoLogin() {
        needLogin = true
    }
    
    func logout() {
        isLogin = false
        gotoLogin()
    }
    
    func loginSuccess() {
        isLogin = true
    }
}
