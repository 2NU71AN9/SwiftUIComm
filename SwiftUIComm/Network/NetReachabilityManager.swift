//
//  NetReachabilityManager.swift
//  SLCommProject
//
//  Created by 孙梁 on 2020/12/11.
//

import Alamofire

enum NetworkReachabilityStatus {
    case unknown
    case notReachable
    case cellular
    case WiFi

    var statusStr: String {
        switch self {
        case .unknown:
            return "未识别的网络"
        case .notReachable:
            return "不可用的网络(未连接)"
        case .cellular:
            return "数据"
        case .WiFi:
            return "WiFi"
        }
    }
}

class NetReachabilityManager {

    /// 当前网络状态
    private(set) var cur_status: NetworkReachabilityStatus = .WiFi

    static let shared: NetReachabilityManager = {
        let shared = NetReachabilityManager()
        shared.listen()
        return shared
    }()

    private let manager = NetworkReachabilityManager()

    func listen() {
        manager?.startListening { [weak self] status in
            switch status {
            case .unknown:
                self?.cur_status = .unknown
            case .notReachable:
                self?.cur_status = .notReachable
            case .reachable:
                if self?.manager?.isReachableOnCellular ?? false {
                    self?.cur_status = .cellular
                } else if self?.manager?.isReachableOnEthernetOrWiFi ?? false {
                    self?.cur_status = .WiFi
                }
            }
        }
    }
}
