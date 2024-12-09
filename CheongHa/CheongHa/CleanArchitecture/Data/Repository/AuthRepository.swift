//
//  AuthRepository.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/9/24.
//

import Foundation
import RxSwift

protocol AuthRepositoryProtocol {
    func logout(api: AuthRouter) -> Single<LogoutDTO>
}

final class AuthRepository: AuthRepositoryProtocol {
    
    private let keychain: KeychainManagerProtocol
    private let network: NetworkManagerProtocol
    
    init(keychain: KeychainManagerProtocol, network: NetworkManagerProtocol) {
        self.keychain = keychain
        self.network = network
    }
    
    func logout(api: AuthRouter) -> Single<LogoutDTO> {
        network
            .request(api, decodingType: LogoutDTO.self)
            .deleteTokens(keychain)
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == LogoutDTO {
    
    func deleteTokens(_ keychain: KeychainManagerProtocol) -> Single<Element> {
        return map {
            keychain.delete(account: "accessToken")
            keychain.delete(account: "refreshToken")
            return $0
        }
    }
}
