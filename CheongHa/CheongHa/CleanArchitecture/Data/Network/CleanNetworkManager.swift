//
//  CleanNetworkManager.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/4/24.
//

import Foundation
import Moya
import RxSwift

protocol NetworkManagerProtocol: Sendable {
    func reqeust<Target: TargetType>(_ target: Target) -> Single<Response>
}

final class CleanNetworkManager: NetworkManagerProtocol {
    
    func reqeust<Target: TargetType>(_ target: Target) -> Single<Response> {
        return performReqeust(target)
    }
    
    private func performReqeust<Target: TargetType>(_ target: Target) -> Single<Response> {
        let session = Session(interceptor: AuthInterceptor.shared)
        let provider = MoyaProvider<Target>(session: session)
        
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
