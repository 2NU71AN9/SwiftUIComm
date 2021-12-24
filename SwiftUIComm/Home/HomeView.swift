//
//  HomeView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/15.
//

import SwiftUI
import Introspect
import SLIKit

struct HomeView: View {

    @StateObject var vm = HomeViewModel()

    var body: some View {
        List {
            Group {
                NavigationLink("网络请求") { NetRequestView() }
                NavigationLink("自定义返回") { SecondView() }
                NavigationLink("NaviPagerView") { NaviPagerView() }
                NavigationLink("PagerView") { PagerView() }
                NavigationLink("下拉刷新&上拉加载") { RefreshView() }
                NavigationLink("Codable") { CodableView() }
                NavigationLink("GCD") { GCDView() }
                NavigationLink("RunLoop") { RunLoopView() }
                NavigationLink("属性包装器") { PropertyWrappersView() }
                Text(UserDefaults.standard.value(forKey: "AA") as? String ?? "")
            }
            Group {
                NavigationLink("自定义环境变量") { CustomEnviroment() }
            }
        }
        .sl_state()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
