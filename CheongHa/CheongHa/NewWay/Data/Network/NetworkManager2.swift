//
//  NetworkManager2.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/3/24.
//

import Foundation
import Moya
import RxSwift

protocol NetworkManagerProtocol {
    func reqeust<Target: TargetType>(_ target: Target) -> Single<Response>
}

final class NetworkManager2: NetworkManagerProtocol {
    
    func reqeust<Target: TargetType>(_ target: Target) -> Single<Response> {
        return performReqeust(target)
    }
    
    private func performReqeust<Target: TargetType>(_ target: Target) -> Single<Response> {
        let provider = MoyaProvider<Target>()
        return Single<Response>.create { [weak self] singleObserver in
            guard self != nil else { return Disposables.create() }
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    singleObserver(.success(response))
                case .failure(let moyaError):
                    singleObserver(.failure(moyaError))
                }
            }
            return Disposables.create()
        }
    }
}
