//
//  PropertyWrappersView.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/6.
//

import SwiftUI

struct PropertyWrappersView: View {
    
    @NoSpace var str = " 1 23 "
    @UserDefault(key: "MyKey") var a = "123555556666"
    
    var body: some View {
        VStack {
            Text(str)
                .background(Color.red)
        }
    }
}

struct PropertyWrappersView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyWrappersView()
    }
}
