//
//  PropertyWrappersView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/6.
//

import SwiftUI
import Combine
import SwiftUIX

struct PropertyWrappersView: View {
    
    @AppStorage("AA") var a = "qqqqq"
    
    @NoSpace var str = " 1 23 "
    
    let obj = MyObject()
    @State var cancellables = Set<AnyCancellable>()
    
    
    @State var str2 = "QQQ"
    
    var body: some View {
        VStack {
            Text(self.a)
                .background(Color.red)
            Text("\(obj.myValue)")
            TextField("", text: $a)
        }.onAppear {
            obj.$myValue.sink { i in
                print(i)
            }
            .store(in: &self.cancellables)
        }
    }
}

struct PropertyWrappersView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyWrappersView()
    }
}


class MyObject {
    @DebouncePublisher(debounce: 1) var myValue = ""
}

