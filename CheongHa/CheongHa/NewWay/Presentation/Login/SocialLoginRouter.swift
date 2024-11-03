//
//  SocialLoginRouterProtocol.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/3/24.
//

import UIKit
import GoogleSignIn

protocol SocialLoginRouterProtocol {
    func routeToGoogleLogin(completion: ((GIDSignInResult?, Error?) -> Void)?)
}

/// 소셜로그인 라우터
final class SocialLoginRouter: SocialLoginRouterProtocol {
        
    /// 구글 로그인 화면으로 이동
    func routeToGoogleLogin(completion: ((GIDSignInResult?, Error?) -> Void)?) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }
                
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController, completion: completion)
    }
}
