//
//  GoogleSignInManager.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/7/24.
//

import Foundation
import GoogleSignIn

final class GoogleSignInManager {
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    func fetchIdToken(view: UIViewController, completion: @escaping (Result<String, GoogleSignError>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: view) { signInResult, error in
            guard error == nil else {
                completion(.failure(.googleNetworkError))
                return
            }
            
            guard let signInResult = signInResult else {
                completion(.failure(.signInResult))
                return
            }
            
            let user = signInResult.user
            guard let idtoken = user.idToken?.tokenString else {
                completion(.failure(.idtokenError))
                return
            }
            
            completion(.success(idtoken))
        }
    }
}
