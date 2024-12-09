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
    func withdrawal(api: AuthRouter) -> Single<WithdrawalDTO>
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
    
    func withdrawal(api: AuthRouter) -> Single<WithdrawalDTO> {
        network
            .request(api, decodingType: WithdrawalDTO.self)
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

extension PrimitiveSequence where Trait == SingleTrait, Element == WithdrawalDTO {
    
    func deleteTokens(_ keychain: KeychainManagerProtocol) -> Single<Element> {
        return map {
            keychain.delete(account: "accessToken")
            keychain.delete(account: "refreshToken")
            return $0
        }
    }
}
