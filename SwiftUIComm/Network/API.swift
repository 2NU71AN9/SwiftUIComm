//
//  API.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/11.
//

import UIKit
import SLIKit
import Moya

/// 网络请求返回数据结构
public struct NetworkResponse {
    var success: Bool = false
    var code: Int = 300
    var message: String?
    var result: Any?
    
    init(_ dict: [String: Any]) {
        if let success = dict["success"] as? Bool {
            self.success = success
        }
        if let code = dict["code"] as? Int {
            self.code = code
        }
        if let message = dict["message"] as? String {
            self.message = message
        }
        if let result = dict["result"] {
            self.result = result
        }
    }
}

/// 各code代表什么
public enum HttpCode: Int {
    case success = 0 // 成功
    case logout = 14007 // token过期
    case requestFailed = 1000 // 网络请求失败
    case failed = 300 // 失败
    case noDataOrDataParsingFailed = 301 // 无数据或解析失败

    var logoutCode: [Int] { [rawValue, 14006] }
}

public enum APIError: Swift.Error {
    case loadFailed(message: String?)
    case mappingFailed(message: String?)
    case failed(message: String?)
    case error(error: Error?)
    case moyaError(error: MoyaError?)
    case unknown
}

// MARK: - 输出error详细信息
extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .loadFailed(let message):
            #if DEBUG
            SLHUD.toast(String(describing: message))
            #endif
            return String(describing: message)
        case .mappingFailed(let message):
            #if DEBUG
            SLHUD.toast(String(describing: message))
            #endif
            return String(describing: message)
        case .failed(let message):
            #if DEBUG
            SLHUD.toast(String(describing: message))
            #endif
            return String(describing: message)
        case .error(let error):
            #if DEBUG
            SLHUD.toast(String(describing: error))
            #endif
            return error.debugDescription
        case .moyaError(let error):
            #if DEBUG
            SLHUD.toast(String(describing: error?.errorDescription))
            #endif
            return error?.errorDescription
        case .unknown:
            #if DEBUG
            SLHUD.toast("未知错误")
            #endif
            return "未知错误"
        }
    }
}
