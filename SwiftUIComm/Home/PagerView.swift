//
//  PagerView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/19.
//

import SwiftUI
import SwiftUIX
import SLIKit

struct PagerView: View {
    
    @State var curindex = 0
    
    var body: some View {
        PaginationView(axis: .horizontal) {
            ForEach(0..<10) { index in
                ContentView(index: index+1)
            }
        }
        .currentPageIndex($curindex)
        .pageIndicatorAlignment(.top)
        .pageIndicatorTintColor(.gray)
        .currentPageIndicatorTintColor(.orange)
        .navigationTitle("PagerView")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    struct ContentView: View {
        
        var index: Int
        
        init(index: Int) {
            self.index = index
            print("创建\(index)")
        }
        
        var body: some View {
            ZStack {
                Color(UIColor.sl.random)
                Text(String(index))
            }
        }
    }
}

struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        PagerView()
    }
}
