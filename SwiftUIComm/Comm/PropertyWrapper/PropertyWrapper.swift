//
//  PropertyWrapper.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/6.
//

/// 去除首尾空格与换行
@propertyWrapper
struct NoSpace {
    private var value: String
    
    var wrappedValue: String {
        get { value }
        set {
            value = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    var projectedValue: String {
        get { wrappedValue }
        set { wrappedValue = newValue }
    }
    
    init(wrappedValue initialValue: String = "") {
        value = initialValue
        wrappedValue = initialValue
    }
}

/// 属性持久化UserDefault
@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private var value: T?
    
    var wrappedValue: T? {
        mutating get {
            if let value = value {
                return value
            }
            value = UserDefaults.standard.value(forKey: key) as? T
            return value
        }
        set {
            value = newValue
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    init(wrappedValue initialValue: T?, key: String) {
        self.key = key
        wrappedValue = initialValue
    }
}
