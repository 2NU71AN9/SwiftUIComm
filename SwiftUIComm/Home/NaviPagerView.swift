//
//  NaviPagerView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/19.
//

import SwiftUI
import PagerTabStripView

struct NaviPagerView: View {
    
    @State var index = 0
    
    var body: some View {
        PagerTabStripView(selection: $index) {
            List {
                Text("第1页")
            }.pagerTabItem {
                CustomTitleItem(title: "Tab1")
            }
            List {
                Text("第2页")
            }.pagerTabItem {
                CustomTitleItem(title: "Tab2")
            }
            List {
                Text("第3页")
            }.pagerTabItem {
                CustomTitleItem(title: "Tab3")
            }
            List {
                Text("第4页")
            }.pagerTabItem {
                CustomTitleItem(title: "Tab4")
            }
            List {
                Text("第5页")
            }.pagerTabItem {
                CustomTitleItem(title: "Tab5")
            }
            List {
                Text("第6页")
            }.pagerTabItem {
                CustomTitleItem(title: "Tab6")
            }
            List {
                Text("第7页")
            }.pagerTabItem {
                CustomTitleItem(title: "Tab7")
            }
            List {
                Text("第8页")
            }.pagerTabItem {
                CustomTitleItem(title: "Tab8")
            }
            List {
                Text("第9页")
            }.pagerTabItem {
                CustomTitleItem(title: "Tab9")
            }
            List {
                Text("第10页")
            }.pagerTabItem {
                CustomTitleItem(title: "Tab10")
            }
        }
        .frame(alignment: .center)
        .pagerTabStripViewStyle(.scrollableBarButton(indicatorBarColor: .accentColor, tabItemSpacing: 10, tabItemHeight: 30))
        .navigationTitle("NaviPagerView")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NaviPagerView_Previews: PreviewProvider {
    static var previews: some View {
        NaviPagerView()
    }
}


private class ButtonTheme: ObservableObject {
    @Published var textColor = Color.gray
}
struct CustomTitleItem: View, PagerTabViewDelegate {
    let title: String
    
    @ObservedObject fileprivate var theme = ButtonTheme()
    
    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(theme.textColor)
                .font(.subheadline)
        }
        .background(Color.clear)
    }
    
    func setState(state: PagerTabViewState) {
        switch state {
        case .selected:
            self.theme.textColor = .accentColor
        case .highlighted:
            self.theme.textColor = .accentColor
        default:
            self.theme.textColor = .label
        }
    }
}
