//
//  API.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/11.
//

/// 网络请求返回数据结构
public struct NetworkResponse {
    var success: Bool = false
    var code: Int = 300
    var message = ""
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
    
    var apiCodeType: APICode {
        switch code {
        case APICode.success.rawValue:
            return .success
        case APICode.signOut.rawValue:
            return .signOut
        default:
            return .failure
        }
    }
}
