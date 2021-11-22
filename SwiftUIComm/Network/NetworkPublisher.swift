//
//  NetworkPublisher.swift
//  SwiftUIComm
//
//  Created by 孙梁 on 2021/11/22.
//

import Combine
import Moya
import SLIKit

public extension Publisher where Failure == MoyaError {
    func mapNetworkResponse() -> Publishers.TryMap<Self, NetworkResponse> {
        tryMap { dict -> NetworkResponse in
            guard let dict = dict as? [String: Any] else {
                throw APIError.mappingFailed(message: "非JSON数据")
            }
            let response = NetworkResponse(dict)
            if response.apiCodeType == .success {
                return response
            } else if response.apiCodeType == .signOut {
                throw APIError.signOut(message: response.message)
            } else {
                throw APIError.failed(message: response.message)
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

public extension Publisher where Output == NetworkResponse {
    
    func transfromNetworkResponse(_ path: String? = nil) -> Publishers.TryMap<Self, NetworkResponse> {
        tryMap { response -> NetworkResponse in
            var response = response
            path?.components(separatedBy: ".").forEach { (str) in
                if let result = response.result as? [String: Any] {
                    response.result = result[str]
                }
            }
            return response
        }
    }
    
    func mapModel<T: Codable>(_ type: T.Type) -> Publishers.TryMap<Self, T> {
        tryMap { res -> T in
            if let dict = res.result as? [String: Any],
               let model = try? JSONDecoder().decode(T.self, from: Data(dict.description.utf8)) {
                return model
            }
            throw APIError.mappingFailed(message: "转Model失败")
        }
    }
    
    func mapModels<T: Codable>(_ type: T.Type) -> Publishers.TryMap<Self, [T]> {
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
    func showError() -> Publishers.HandleEvents<Self> {
        handleEvents(receiveCompletion:  { completion in
            switch completion {
            case .failure(let error):
                switch error {
                case .signOut(let message):
                    AccountServicer.shared.signOut()
                    SLHUD.toast(message)
                default:
                    SLHUD.toast(error.errorDescription)
                }
            default:
                break
            }
        })
    }
}
