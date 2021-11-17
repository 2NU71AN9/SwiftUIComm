//
//  HomeView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/15.
//

import SwiftUI

struct HomeView: View {

    @StateObject var vm = HomeViewModel()
    
    var body: some View {
        Text("首页")
            .state()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

