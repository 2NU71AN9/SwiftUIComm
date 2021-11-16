//
//  DiscoverView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/15.
//

import SwiftUI

struct DiscoverView: StateView {
    
    @EnvironmentObject var shared: AccountServicer
    
    var master: some View {
        Text("发现")
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
