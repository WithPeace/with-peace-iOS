//
//  AuthUsecase.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/9/24.
//

import Foundation
import RxSwift

protocol AuthUsecaseProtocol {
    func logout() -> Single<LogoutDTO>
}

final class AuthUsecase: AuthUsecaseProtocol {
    
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol ) {
        self.authRepository = authRepository
    }
    
    func logout() -> Single<LogoutDTO> {
        return authRepository.logout(api: .logout)
    }
}
