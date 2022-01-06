//
//  SearchingListView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2022/1/6.
//

import SwiftUI

struct SearchingListView: View {
    
    @State private var searchText = ""
    @State private var dataArray = ["🍎QQQ", "🍐FDS", "🍎POFSD", "🍐VX.C", "🍐DA,.XZ", "🍌BBL;D"]
    
    private var dataResult: [String] {
        searchText.isEmpty ? dataArray : dataArray.filter { $0.contains(searchText) }
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            List(dataResult, id: \.self) {
                Text($0)
            }
            .searchable(text: $searchText, placement: .automatic, prompt: Text("输入搜索内容"))
//            {
//                Text("🍎").searchCompletion("🍎")
//                Text("🍐").searchCompletion("🍐")
//                Text("🍌").searchCompletion("🍌")
//            }
//            .onSubmit(of: .search) {
//                print("searchsearchsearch")
//            }
            .navigationTitle("搜索列表")
        } else {
            // Fallback on earlier versions
        }
    }
}

struct SearchingListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingListView()
    }
}
