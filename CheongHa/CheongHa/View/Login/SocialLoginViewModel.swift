//
//  SocialLoginViewModel.swift
//  WithPeace
//
//  Created by Hemg on 3/15/24.
//

import RxSwift
import GoogleSignIn
import AuthenticationServices

final class SocialLoginViewModel: NSObject {
    
    private let signinManager: AuthenticationProvider
    private let disposeBag = DisposeBag()
    
    private let socialLoginRouter: SocialLoginRouterProtocol
    private let loginUsecase: LoginUsecaseProtocol
    
    let appleLoginSuccess = PublishSubject<String>()
    let signInSuccess: PublishSubject<(token: String, role: Role)> = PublishSubject()
    let signInFailure: PublishSubject<String> = PublishSubject()
    
    init(
        googleSigninManager: AuthenticationProvider,
        socialLoginRouter: SocialLoginRouterProtocol,
        loginUsecase: LoginUsecaseProtocol
    ) {
        self.signinManager = googleSigninManager
        self.socialLoginRouter = socialLoginRouter
        self.loginUsecase = loginUsecase
        
        super.init()

        self.appleLoginSuccess
            .withUnretained(self)
            .flatMap { owner, idToken in
                owner.loginUsecase
                    .performAppleLogin(idToken: idToken)
            }
            .subscribe { data in
                guard let role = data.data.role else { return }
                
                switch role {
                case .guest:
                    self.signInSuccess.onNext(("Token: \(data)", Role.guest))
                case .user:
                    self.signInSuccess.onNext(("Token: \(data)", Role.user))
                }
            }
            .disposed(by: disposeBag)
        
//        self.appleLoginSuccess.subscribe { [weak self] id in
//            guard let self else { return }
//            
//            signinManager.performAppleLogin(idToken: id) { result in
//                switch result {
//                case .success(let data):
//                    guard let role = data.data.role else { return }
//                    
//                    switch role {
//                    case .guest:
//                        self.signInSuccess.onNext(("Token: \(data)", Role.guest))
//                    case .user:
//                        self.signInSuccess.onNext(("Token: \(data)", Role.user))
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }.disposed(by: disposeBag)
    }
}

//MARK: Google Login
extension SocialLoginViewModel {
    
    func routeToGoogleLoginView() {
        socialLoginRouter.routeToGoogleLoginView { [weak self] signIn, error in
            guard let self else { return }
            
            if let error = error {
                debugPrint(error)
                self.signInFailure.onNext("로그인에 실패했습니다")
            }
            
            guard let signIn = signIn else { return }
            let user = signIn.user
            guard let idToken = user.idToken?.tokenString else { return }
            
            performGoogleLogin(idToken: idToken)
        }
    }
    
    private func performGoogleLogin(idToken: String) {
        loginUsecase
            .performGoogleLogin(idToken: idToken)
            .subscribe(with: self) { owner, data in
                if data.error == nil {
                    guard let role = data.data.role else { return }
                    switch role {
                    case .guest:
                        owner.signInSuccess.onNext(("Token: \(data)", Role.guest))
                    case .user:
                        owner.signInSuccess.onNext(("Token: \(data)", Role.user))
                    }
                } else {
                    print("error", data.error?.message ?? "")
                    owner.signInFailure.onNext("삭제된 계정입니다.")
                }
            }
            .disposed(by: disposeBag)
    }
}

//MARK: Apple Login
extension SocialLoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    /// 애플 로그인 띄워주는 메서드
    func handleAuthorizationAppleIDButtonPress() {
        socialLoginRouter.routeToAppleLoginView(self)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { fatalError("No window found.") }
        return window
    }
    
    // 인증 성공시 호출
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let id = String(data: appleIDCredential.identityToken!, encoding: .utf8) else {
                return
            }
            
            appleLoginSuccess.onNext(id)
            
        case let passwordCredential as ASPasswordCredential:
            print("passwordCredential: ", passwordCredential)
            print(passwordCredential.user)
            print(passwordCredential.password)
        default:
            signInFailure.onNext("로그인에 실패했습니다.")
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("인증 실패, ERROR authorizationController 호출")
        signInFailure.onNext("로그인에 실패했습니다.")
    }
}
