//
//  SocialLoginViewModel.swift
//  WithPeace
//
//  Created by Hemg on 3/15/24.
//

import RxSwift
import GoogleSignIn

final class SocialLoginViewModel {
    private let googleSigninManager: AuthenticationProvider
    private let disposeBag = DisposeBag()
    
    let signInSuccess: PublishSubject<String> = PublishSubject()
    let signInFailure: PublishSubject<Error> = PublishSubject()
    
    init(googleSigninManager: AuthenticationProvider) {
        self.googleSigninManager = googleSigninManager
    }
    
    func signInWithGoogle() -> Observable<Result<String, Error>> {
        return Observable.create { observer in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                observer.onNext(.failure(NSError(domain: "No active window scene", code: 0)))
                return Disposables.create()
            }
            
            guard let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
                observer.onNext(.failure(NSError(domain: "No key window found", code: 0)))
                return Disposables.create()
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signIn, error in
                if let error = error {
                    observer.onNext(.failure(error))
                }
                
                guard let signIn = signIn else { return }
                let user = signIn.user
                guard let idToken = user.idToken?.tokenString else { return }
                
                self.performGoogleSignIn(idToken: idToken)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func performGoogleSignIn(idToken: String) {
        googleSigninManager.performGoogleSign(idToken: idToken) { [weak self] result in
            switch result {
            case .success(let data):
                self?.signInSuccess.onNext("Token: \(data)")
            case .failure(let error):
                self?.signInFailure.onNext(error)
            }
        }
    }
}
