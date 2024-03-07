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
    
//    func tabGoogle() {
//        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
//          guard error == nil else { return }
//            //TODO: 로그인 성공적으로 받아지면 실행되는 main View 담아주는 곳.
//          // If sign in succeeded, display the app's main content View.
//        }
//    }
}
