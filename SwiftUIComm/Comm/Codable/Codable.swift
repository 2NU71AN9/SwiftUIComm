//
//  Codable.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/24.
//

// 将获取的String转化为Double
public struct DoubleConverter: Codable {

    let value: Double?

    public init(_ value: Double = 0) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        value = Double(string)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode("\(value ?? 0)")
    }
}

// 将获取的String/Int/Bool转化为Bool
public struct BoolConverter: Codable {

    var value = false
    
    private var valueType: ValueType = .bool
    
    private enum ValueType {
        case bool
        case string
        case int
    }

    public init(_ value: Bool = false) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            value = string == "true"
            valueType = .string
        } else if let int = try? container.decode(Int.self) {
            value = int == 1
            valueType = .int
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
            valueType = .bool
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch valueType {
        case .bool:
            try container.encode(value)
        case .string:
            try container.encode(value ? "true" : "false")
        case .int:
            try container.encode(value ? 1 : 0)
        }
    }
}
