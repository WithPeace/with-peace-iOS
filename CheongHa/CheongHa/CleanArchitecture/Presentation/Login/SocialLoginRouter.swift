//
//  SocialLoginRouter.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/3/24.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

protocol SocialLoginRouterProtocol {
    func routeToGoogleLoginView(completion: ((GIDSignInResult?, Error?) -> Void)?)
    func routeToAppleLoginView(_ viewModel: SocialLoginViewModel)
}

/// 소셜로그인 라우터
final class SocialLoginRouter: SocialLoginRouterProtocol {
        
    /// 구글 로그인 화면으로 이동
    func routeToGoogleLoginView(completion: ((GIDSignInResult?, Error?) -> Void)?) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }
                
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController, completion: completion)
    }
    
    /// 애플 로그인 화면으로 이동
    func routeToAppleLoginView(_ viewModel: SocialLoginViewModel) {
        print("handleAuthorizationAppleIDButtonPress 호출")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.requestedScopes = []
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = viewModel
        authorizationController.presentationContextProvider = viewModel
        authorizationController.performRequests()
    }
}
