//
//  Ex_Binding.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/24.
//

import SwiftUI

public extension Binding {
    func willSet(_ willSet: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(get: { wrappedValue },
                set: { newValue in
                    willSet(newValue)
                    self.wrappedValue = newValue
                })
    }
    
    func didSet(_ didSet: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(get: { wrappedValue },
                set: { newValue in
                    self.wrappedValue = newValue
                    didSet(newValue)
                })
    }
}
