//
//  DiscoverView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/15.
//

import SwiftUI

struct DiscoverView: View {
    
    @StateObject var vm = DiscoverViewModel()
    
    var body: some View {
        Text("发现")
            .state()
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
