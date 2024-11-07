//
//  LoginRepository.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/4/24.
//

import Foundation
import RxMoya
import RxSwift

// TODO: 명칭 변경 Login -> Auth
protocol LoginRepositoryProtocol {
    func performGoogleLogin(api: LoginRouter) -> Single<SocialLoginDTO>
    func performAppleLogin(api: LoginRouter) -> Single<SocialLoginDTO>
}

final class LoginRepository: LoginRepositoryProtocol {
    
    private let keychain: KeychainManagerProtocol
    private let network: NetworkManagerProtocol
    
    init(keychain: KeychainManagerProtocol, network: NetworkManagerProtocol) {
        self.keychain = keychain
        self.network = network
    }
    
    func performGoogleLogin(api: LoginRouter) -> Single<SocialLoginDTO> {
        network
            .request(api, decodingType: SocialLoginDTO.self)
            .saveTokens(keychain)
    }
    
    func performAppleLogin(api: LoginRouter) -> Single<SocialLoginDTO> {
        network
            .request(api, decodingType: SocialLoginDTO.self)
            .saveTokens(keychain)
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == SocialLoginDTO {
    
    func saveTokens(_ keychain: KeychainManagerProtocol) -> Single<Element> {
        return map {
            
            guard let accessToken = $0.data?.jwtTokenDto.accessToken,
                  let refreshToken = $0.data?.jwtTokenDto.refreshToken,
                  let refreshToken = refreshToken.data(using: .utf8),
                  let accessToken = accessToken.data(using: .utf8)
            else {
                throw SignRepositoryError.invalidToken
            }
            
            try keychain.save(account: "accessToken", password: accessToken)
            try keychain.save(account: "refreshToken", password: refreshToken)

            return $0
        }
    }
}
