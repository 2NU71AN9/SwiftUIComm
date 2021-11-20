//
//  RefreshView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/19.
//

import SwiftUI
import SLIKit
import Combine

struct RefreshView: View {
    
    @State var isRefreshing = false
    @State var isLoadingMore = false
    @State var isNoMore = false
    
    @State var dataArray = [Int](repeating: Int.random(in: 0 ... 100), count: 10)
    
    var body: some View {
        MList(isRefreshing: $isRefreshing, isLoadingMore: $isLoadingMore, isNoMore: $isNoMore, refreshAction: refresh, loadingMoreAction: loadMore, content: {
            ForEach(dataArray, id: \.self) {
                Text("\($0)")
            }
        })
        .navigationTitle("下拉刷新&上拉加载")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func refresh() {
        SL.delay(second: 1) {
            isRefreshing = false
            dataArray = [Int](repeating: Int.random(in: 0 ... 100), count: 10)
        }
    }
    private func loadMore() {
        SL.delay(second: 1) {
            isLoadingMore = false
            isNoMore = true
            dataArray += [Int](repeating: Int.random(in: 0 ... 100), count: 10)
        }
    }
}

struct RefreshView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshView()
    }
}
