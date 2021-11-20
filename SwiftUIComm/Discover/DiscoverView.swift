//
//  DiscoverView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/15.
//

import SwiftUI
import SwiftUIX
import SLIKit

struct DiscoverView: View {
    
    @StateObject var vm = DiscoverViewModel()
    
    var body: some View {
        Text("发现")
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
