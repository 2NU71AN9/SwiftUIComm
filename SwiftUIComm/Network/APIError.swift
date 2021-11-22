//
//  APIError.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/22.
//

import Moya

/// 各code代表什么
public enum APICode: Int {
    case success = 200 // 成功
    case signOut = 401 // 登出
    case failure = 300 // 失败
}

/// 网络请求Error
public enum APIError: Swift.Error {
    case signOut(message: String?)
    case mappingFailed(message: String?)
    case failed(message: String?)
    case error(error: Error?)
    case moyaError(error: MoyaError?)
    case unknown
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .signOut(let message):
            return message
        case .mappingFailed(let message):
            return message
        case .failed(let message):
            return message
        case .error(let error):
            return error.debugDescription
        case .moyaError(let error):
            return error?.errorDescription
        case .unknown:
            return "未知错误"
        }
    }
}
