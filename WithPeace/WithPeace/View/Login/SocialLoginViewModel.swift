//
//  SocialLoginViewModel.swift
//  WithPeace
//
//  Created by Hemg on 3/15/24.
//

import RxSwift
import GoogleSignIn
import RxCocoa

final class SocialLoginViewModel {
    private let googleSigninManager: AuthenticationProvider
    private let disposeBag = DisposeBag()
    private var isSign = false
    let signInSuccess: PublishSubject<String> = PublishSubject()
    let signInFailure: PublishSubject<Error> = PublishSubject()
    
    init(googleSigninManager: AuthenticationProvider) {
        self.googleSigninManager = googleSigninManager
    }
    
    private func signInWithGoogle(presentVC: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presentVC) { [weak self] signIn, error in
            guard let self else { return }
            self.isSign = false
            
            if let error = error {
                self.signInFailure.onNext(error)
            }
            
            guard let signIn = signIn else { return }
            let user = signIn.user
            guard let idToken = user.idToken?.tokenString else { return }
            
            self.performGoogleSignIn(idToken: idToken)
        }
    }
    
    private func performGoogleSignIn(idToken: String) {
        googleSigninManager.performGoogleSign(idToken: idToken) { [weak self] result in
            switch result {
            case .success(let data):
                self?.signInSuccess.onNext("Token: \(data)")
            case .failure(let error):
                self?.signInFailure.onNext(error)
            }
        }
    }
    
    func performGoogleLogin() {
        guard !isSign else { return }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }
        
        isSign = true
        self.signInWithGoogle(presentVC: rootViewController)
    }
}
