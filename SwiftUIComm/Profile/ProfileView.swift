//
//  ProfileView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/15.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var shared: AccountServicer
    @StateObject var vm = ProfileViewModel()
    
    var body: some View {
        Text("我的")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("退出登录") {
                        shared.logout()
                    }
                }
            }
            .state()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}