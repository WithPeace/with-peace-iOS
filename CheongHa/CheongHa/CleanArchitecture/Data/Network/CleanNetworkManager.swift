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
    func request<T: TargetType, D: DTOType>(_ target: T, decodingType: D.Type) -> Single<D>
}

final class CleanNetworkManager: NetworkManagerProtocol {
    
    private let keychain: KeychainManagerProtocol
    
    init() {
        self.keychain = KeychainManager()
    }
    
    func request<T: TargetType, D: DTOType>(_ target: T, decodingType: D.Type) -> Single<D> {
        return performReqeust(target)
            .filter(statusCodes: 200...500)
            .map(decodingType.self)
            .catchExpiredToken(keychain)
    }
    
    private func performReqeust<T: TargetType>(_ target: T) -> Single<Response> {
        
        let provider = MoyaProvider<T>()
        
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

// MARK: 토큰 갱신
extension PrimitiveSequence where Trait == SingleTrait, Element: DTOType {
    
    func catchExpiredToken(_ keychain: KeychainManagerProtocol) -> Single<Element> {
        return map { element in
            if let error = element.error, error.code == 40100 {
                let provider = MoyaProvider<LoginRouter>()
                
                provider.request(.refreshToken) { result in
                    switch result {
                    case .success(let response):
                        print("토큰 갱신 완료")
                        saveUpdatedTokens(response.data, keychain: keychain)
                    case .failure(let error):
                        print("토큰 갱신 중 에러가 발생했습니다. - \(error)")
                    }
                }
            }
            return element
        }
    }
    
    private func saveUpdatedTokens(_ data: Data, keychain: KeychainManagerProtocol) {
        do {
            let decodedData = try JSONDecoder().decode(RefreshedTokenDTO.self, from: data)
            
            guard let accessToken = decodedData.data?.accessToken,
                  let refreshToken = decodedData.data?.refreshToken,
                  let refreshTokenData = refreshToken.data(using: .utf8),
                  let accessTokenData = accessToken.data(using: .utf8)
            else { return }
            
            try keychain.save(account: "accessToken", password: accessTokenData)
            try keychain.save(account: "refreshToken", password: refreshTokenData)
            
        } catch {
            print("갱신된 토큰 저장 중 오류 발생!! - \(error)")
        }
    }
}
