//
//  SearchingListView.swift
//  SwiftUIComm
//
//  Created by ๅญๆข on 2022/1/6.
//

import SwiftUI

struct SearchingListView: View {
    
    @State private var searchText = ""
    @State private var dataArray = ["๐QQQ", "๐FDS", "๐POFSD", "๐VX.C", "๐DA,.XZ", "๐BBL;D"]
    
    private var dataResult: [String] {
        searchText.isEmpty ? dataArray : dataArray.filter { $0.contains(searchText) }
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            List(dataResult, id: \.self) {
                Text($0)
            }
            .searchable(text: $searchText, placement: .automatic, prompt: Text("่พๅฅๆ็ดขๅๅฎน"))
//            {
//                Text("๐").searchCompletion("๐")
//                Text("๐").searchCompletion("๐")
//                Text("๐").searchCompletion("๐")
//            }
//            .onSubmit(of: .search) {
//                print("searchsearchsearch")
//            }
            .navigationTitle("ๆ็ดขๅ่กจ")
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
