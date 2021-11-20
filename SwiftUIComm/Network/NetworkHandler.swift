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
        var plugins: [PluginType] = [ShowProgress(), CheckNetStatus()]
        #if DEBUG
        plugins.append(Print())
        #endif
        let provider = MoyaProvider<APIService>(plugins: plugins)
        return provider
    }()
    
    static func request(_ target: APIService) -> AnyPublisher<NetworkResponse, APIError> {
        provider.requestPublisher(target)
            .mapJSON()
            .mapToNetworkResponse(target)
            .mapApiError()
            .showError()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

public extension Publisher where Failure == MoyaError {
    func mapToNetworkResponse(_ target: APIService) -> Publishers.TryMap<Self, NetworkResponse> {
        tryMap { dict -> NetworkResponse in
            if let dict = dict as? [String: Any] {
                var response = NetworkResponse(dict)
                target.responsePath?.components(separatedBy: ".").forEach { (str) in
                    if let result = response.result as? [String: Any] {
                        response.result = result[str]
                    }
                }
                return response
            } else {
                throw APIError.mappingFailed(message: "非JSON数据")
            }
        }
    }
}

public extension Publisher where Output == NetworkResponse {
    func mapApiError() -> Publishers.MapError<Self, APIError> {
        mapError { error -> APIError in
            if let error = error as? APIError {
                return error
            } else if let error = error as? MoyaError {
                return APIError.moyaError(error: error)
            } else {
                return APIError.unknown
            }
        }
    }
}

public extension Publisher where Output == NetworkResponse, Failure == APIError {
    func mapToModel<T: Codable>(type: T.Type) -> Publishers.TryMap<Self, T> {
        tryMap { res -> T in
            if let dict = res.result as? [String: Any],
               let model = try? JSONDecoder().decode(T.self, from: Data(dict.description.utf8)) {
                return model
            }
            throw APIError.mappingFailed(message: "转Model失败")
        }
    }
    
    func mapToModels<T: Codable>(type: T.Type) -> Publishers.TryMap<Self, [T]> {
        tryMap { res -> [T] in
            if let array = res.result as? [Any],
               let models = try? JSONDecoder().decode([T].self, from: Data(array.description.utf8)) {
                return models
            }
            throw APIError.mappingFailed(message: "转Models失败")
        }
    }
}

public extension Publisher where Failure == APIError {
    func showError() -> AnyPublisher<Output, Failure> {
        handleEvents(receiveCompletion:  { completion in
            switch completion {
            case .failure(let error):
                SLHUD.toast(error.errorDescription)
            default:
                break
            }
        }).eraseToAnyPublisher()
    }
}
