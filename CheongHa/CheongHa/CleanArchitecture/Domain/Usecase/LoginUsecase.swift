//
//  LoginUsecase.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/4/24.
//

import Foundation
import RxSwift

protocol LoginUsecaseProtocol {
    func performGoogleLogin(idToken: String) -> Single<SignAuthDTO>
    func performAppleLogin(idToken: String) -> Single<SignAuthDTO>
}

final class LoginUsecase: LoginUsecaseProtocol {
    
    private let loginRepository: LoginRepositoryProtocol
    
    init(loginRepository: LoginRepositoryProtocol ) {
        self.loginRepository = loginRepository
    }
    
    func performGoogleLogin(idToken: String) -> Single<SignAuthDTO> {
        return loginRepository.performGoogleLogin(api: .googleSocialLogin(idToken: idToken))
    }
    
    func performAppleLogin(idToken: String) -> Single<SignAuthDTO> {
        return loginRepository.performAppleLogin(api: .googleSocialLogin(idToken: idToken))
    }
}


