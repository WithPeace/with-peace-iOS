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
    func withdrawal() -> Single<WithdrawalDTO>
}

final class AuthUsecase: AuthUsecaseProtocol {
   
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol ) {
        self.authRepository = authRepository
    }
    
    func logout() -> Single<LogoutDTO> {
        return authRepository.logout(api: .logout)
    }
    
    func withdrawal() -> Single<WithdrawalDTO> {
        return authRepository.withdrawal(api: .withdrawal)
    }
}
