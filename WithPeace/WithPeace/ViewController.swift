//
//  ViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/7/24.
//

import UIKit
import GoogleSignIn

final class ViewController: UIViewController {
    
    private let keychainManager = KeychainManager()
    
    //TODO: - 이미지 변경
    let signInButton: GIDSignInButton = {
        let btn = GIDSignInButton()
        
        btn.style = .wide
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemMint
        
        [signInButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        signInButton.addTarget(self, action: #selector(tabGoogle), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        retrieveTokens()
    }
    
    @objc
    func tabGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            //TODO: 로그인 성공적으로 받아지면 실행되는 main View 담아주는 곳.
            // If sign in succeeded, display the app's main content View.
            
            guard let signInResult = signInResult else { return }
            
            let user = signInResult.user
            let idtoken = user.idToken?.tokenString
            let accesstoken = user.accessToken.tokenString
            let refreshtoken = user.refreshToken.tokenString
            
            if let accessTokenData = accesstoken.data(using: .utf8) {
                do {
                    try self.keychainManager.save(account: "accessToken", password: accessTokenData)
                    print("되는거야? 엑세스")
                } catch {
                    print("accessToken Kechain error: \(error.localizedDescription)")
                }
            }
            
            if let refreshTokenData = refreshtoken.data(using: .utf8) {
                do {
                    try self.keychainManager.save(account: "refreshToken", password: refreshTokenData)
                    print("되는거야? 리프레쉬")
                } catch {
                    print("Keychain error: \(error.localizedDescription)")
                }
            }
        }
    }
}

//MARK: 키체인로직
extension ViewController {
    
    func retrieveTokens() {
        if let accessTokenData = keychainManager.get(account: "accessToken"),
           let accessToken = String(data: accessTokenData, encoding: .utf8) {
            print("access token: \(accessToken)")
        } else {
            print("Access token 없음.")
        }
        
        if let refreshTokenData = keychainManager.get(account: "refreshToken"),
           let refreshToken = String(data: refreshTokenData, encoding: .utf8) {
            print("refresh token: \(refreshToken)")
        } else {
            print("Refresh token 없음.")
        }
    }
    
    //TODO: 토큰삭제할때 사용하기
    private func logoutUser() {
        keychainManager.delete(account: "accessToken")
        keychainManager.delete(account: "refreshToken")
    }
}
