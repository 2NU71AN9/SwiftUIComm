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
    
    @StateObject private var vm = DiscoverViewModel()
    
    @State private var index = 1
    
    var body: some View {
        if #available(iOS 15.0, *) {
            Text("\(index)")
                .sl_state()
                .task {
                    try? await Task.sleep(nanoseconds: 1000000000)
                    index += 1
                    print("###########=>", index)
                }
        } else {
            Text("")
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
