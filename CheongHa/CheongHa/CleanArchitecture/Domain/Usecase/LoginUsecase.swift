//
//  LoginUsecase.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/4/24.
//

import Foundation
import RxSwift

protocol LoginUsecaseProtocol {
    func performGoogleLogin(idToken: String) -> Single<SocialLoginDTO>
    func performAppleLogin(idToken: String) -> Single<SocialLoginDTO>
}

final class LoginUsecase: LoginUsecaseProtocol {
    
    private let loginRepository: LoginRepositoryProtocol
    
    init(loginRepository: LoginRepositoryProtocol ) {
        self.loginRepository = loginRepository
    }
    
    func performGoogleLogin(idToken: String) -> Single<SocialLoginDTO> {
        return loginRepository.performGoogleLogin(api: .googleSocialLogin(idToken: idToken))
    }
    
    func performAppleLogin(idToken: String) -> Single<SocialLoginDTO> {
        return loginRepository.performAppleLogin(api: .appleSocialLogin(idToken: idToken))
    }
}
