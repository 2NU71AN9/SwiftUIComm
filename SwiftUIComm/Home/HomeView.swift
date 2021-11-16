//
//  HomeView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/15.
//

import SwiftUI

struct HomeView: StateView {

    @EnvironmentObject var shared: AccountServicer

    var master: some View {
        Text("首页")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
