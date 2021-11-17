//
//  Tabbar.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/15.
//

import SwiftUI

struct Tabbar: View {
    @EnvironmentObject var shared: AccountServicer
    
    @State private var cur_type: ItemType = .home
    
    var body: some View {
        TabView(selection: $cur_type) {
            NavigationView {
                HomeView().navigationTitle(ItemType.home.title)
            }
            .tabItem { Item(type: .home, cur_type: cur_type) }
            .tag(ItemType.home)
            
            NavigationView {
                DiscoverView().navigationTitle(ItemType.discover.title)
            }
            .tabItem { Item(type: .discover, cur_type: cur_type) }
            .tag(ItemType.discover)
            
            NavigationView {
                ProfileView().navigationTitle(ItemType.profile.title)
            }
            .tabItem { Item(type: .profile, cur_type: cur_type) }
            .tag(ItemType.profile)
        }.sheet(isPresented: $shared.needLogin) {
            NavigationView {
                LoginView().navigationTitle("登录")
            }
        }
    }
    
    private struct Item: View {
        let type: ItemType
        let cur_type: ItemType
        
        var body: some View {
            type == cur_type ? type.selectedImage : type.normalImage
            Text(type.title)
        }
    }
    
    private enum ItemType {
        case home
        case discover
        case profile
        
        var title: String {
            switch self {
            case .home:
                return "首页"
            case .discover:
                return "发现"
            case .profile:
                return "我的"
            }
        }
        var normalImage: Image {
            switch self {
            case .home:
                return Image("tab1_normal")
            case .discover:
                return Image("tab2_normal")
            case .profile:
                return Image("tab3_normal")
            }
        }
        var selectedImage: Image {
            switch self {
            case .home:
                return Image("tab1_selected")
            case .discover:
                return Image("tab2_selected")
            case .profile:
                return Image("tab3_selected")
            }
        }
    }
}

struct Tabbar_Previews: PreviewProvider {
    static var previews: some View {
        Tabbar()
    }
}
