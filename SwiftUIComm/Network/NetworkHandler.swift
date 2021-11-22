//
//  NetworkHandler.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/20.
//

import SwiftUI
import Combine
import Moya
import SwiftyJSON
import SLIKit
import SwiftUIX

struct NetworkHandler {
    static var provider: MoyaProvider<APIService> = {
        var plugins: [PluginType] = [ShowProgress()]
        #if DEBUG
        plugins.append(Print())
        #endif
        let provider = MoyaProvider<APIService>(plugins: plugins)
        return provider
    }()
}

extension NetworkHandler {
    static func request(_ target: APIService) -> AnyPublisher<NetworkResponse, APIError> {
        provider.requestPublisher(target)
            .mapJSON()
            .mapNetworkResponse()
            .transfromNetworkResponse(target.responsePath)
            .mapApiError()
            .showError()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
