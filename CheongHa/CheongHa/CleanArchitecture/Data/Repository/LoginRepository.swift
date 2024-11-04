//
//  LoginRepository.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/4/24.
//

import Foundation
import RxMoya
import RxSwift

protocol LoginRepositoryProtocol {
    func performGoogleLogin(api: LoginRouter) -> Single<SignAuthDTO>
    func performAppleLogin(api: LoginRouter) -> Single<SignAuthDTO>
}

final class LoginRepository: LoginRepositoryProtocol {
    
    private let network: NetworkManagerProtocol
    
    init(network: NetworkManagerProtocol) {
        self.network = network
    }
    
    func performGoogleLogin(api: LoginRouter) -> Single<SignAuthDTO> {
        network
            .reqeust(api)
            .map(SignAuthDTO.self)
    }
    
    func performAppleLogin(api: LoginRouter) -> Single<SignAuthDTO> {
        network
            .reqeust(api)
            .map(SignAuthDTO.self)
    }
}
