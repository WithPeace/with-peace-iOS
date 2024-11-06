//
//  AuthInterceptor.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/6/24.
//

import Foundation
import Alamofire
@preconcurrency import RxSwift

final class AuthInterceptor: RequestInterceptor {
    static let shared = AuthInterceptor()
    
    // TODO: 추후 DIContainer를 통한 의존성 주입으로 리팩토링
    private let network: NetworkManagerProtocol
    private let keychain: KeychainManagerProtocol
    private let disposeBag = DisposeBag()
    
    private init() {
        self.network = CleanNetworkManager()
        self.keychain = KeychainManager()
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        
        if (urlRequest.url?.absoluteString ?? "").contains("refresh") {
            guard let tokenData = keychain.get(account: "refreshToken"),
                  let refreshToken = try? JSONDecoder().decode(String.self, from: tokenData)
            else { return }
            
            let headerValue = "Berear \(refreshToken)"
            urlRequest.setValue(headerValue, forHTTPHeaderField: "Authorization")
        } else {
            guard let tokenData = keychain.get(account: "accessToken"),
                  let accessToken = try? JSONDecoder().decode(String.self, from: tokenData)
            else { return }
            
            let headerValue = "Berear \(accessToken)"
            urlRequest.setValue(headerValue, forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        network
            .reqeust(LoginRouter.refreshToken)
            .filterSuccessfulStatusCodes()
            .map(SignAuthDTO.self)
            .saveTokens(keychain)
            .subscribe { _ in
                completion(.retry)
            }
            .disposed(by: disposeBag)
    }
}
