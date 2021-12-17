//
//  PropertyWrapper.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/12/6.
//

import Combine

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

@propertyWrapper
struct DebouncePublisher<Value> {
    var wrappedValue: Value {
        get { subject.value }
        set { subject.value = newValue }
    }
    private let subject: CurrentValueSubject<Value, Never>
    private let publisher: AnyPublisher<Value, Never>
    
    var projectedValue: AnyPublisher<Value, Never> {
        get { publisher }
    }
    
    init(wrappedValue: Value, debounce: DispatchQueue.SchedulerTimeType.Stride) {
        subject = CurrentValueSubject(wrappedValue)
        publisher = subject.debounce(for: debounce, scheduler: DispatchQueue.global()).eraseToAnyPublisher()
    }
}
