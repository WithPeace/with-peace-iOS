//
//  SocialLoginViewModel.swift
//  WithPeace
//
//  Created by Hemg on 3/15/24.
//

import RxSwift
import GoogleSignIn
import AuthenticationServices

final class SocialLoginViewModel {

    private let signinManager: AuthenticationProvider
    private let disposeBag = DisposeBag()
    
    private let socialLoginRouter: SocialLoginRouterProtocol
    
    let appleLoginSuccess = PublishSubject<String>()
    let signInSuccess: PublishSubject<(token: String, role: Role)> = PublishSubject()
    let signInFailure: PublishSubject<String> = PublishSubject()
    
    init(
        googleSigninManager: AuthenticationProvider,
        socialLoginRouter: SocialLoginRouterProtocol
    ) {
        self.signinManager = googleSigninManager
        self.socialLoginRouter = socialLoginRouter
        
        self.appleLoginSuccess.subscribe { id in
            self.signinManager.performAppleLogin(idToken: id) { result in
                switch result {
                case .success(let data):
                    guard let role = data.data.role else { return }
                    
                    switch role {
                    case .guest:
                        self.signInSuccess.onNext(("Token: \(data)", Role.guest))
                    case .user:
                        self.signInSuccess.onNext(("Token: \(data)", Role.user))
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }.disposed(by: disposeBag)
    }
}

//MARK: Apple Login
extension SocialLoginViewModel {
}

//MARK: Google Login
extension SocialLoginViewModel {
    
    func routeToGoogleLogin() {
        socialLoginRouter.routeToGoogleLogin { [weak self] signIn, error in
            guard let self else { return }
            
            if let error = error {
                debugPrint(error)
                self.signInFailure.onNext("로그인에 실패했습니다")
            }
            
            guard let signIn = signIn else { return }
            let user = signIn.user
            guard let idToken = user.idToken?.tokenString else { return }
            
            self.performGoogleSignIn(idToken: idToken)
        }
    }
    
//    func performGoogleLogin() {
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
//            return
//        }
//        
//        self.signInWithGoogle(presentVC: rootViewController)
//    }
//    
//    private func signInWithGoogle(presentVC: UIViewController) {
//        GIDSignIn.sharedInstance.signIn(withPresenting: presentVC) { [weak self] signIn, error in
//            guard let self else { return }
//            
//            if let error = error {
//                debugPrint(error)
//                self.signInFailure.onNext("로그인에 실패했습니다")
//            }
//            
//            guard let signIn = signIn else { return }
//            let user = signIn.user
//            guard let idToken = user.idToken?.tokenString else { return }
//            
//            self.performGoogleSignIn(idToken: idToken)
//        }
//    }
    
    private func performGoogleSignIn(idToken: String) {
        signinManager.performGoogleSign(idToken: idToken) { [weak self] result in
            switch result {
            case .success(let data):
                guard let role = data.data.role else { return }
                
                switch role {
                case .guest:
                    self?.signInSuccess.onNext(("Token: \(data)", Role.guest))
                case .user:
                    self?.signInSuccess.onNext(("Token: \(data)", Role.user))
                }
                
            case .failure(let error):
                debugPrint("SignIn Error: \(error.localizedDescription)")
                self?.signInFailure.onNext("삭제된 계정입니다.")
            }
        }
    }
}
