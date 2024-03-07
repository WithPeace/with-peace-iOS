//
//  ViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/7/24.
//

import UIKit
import GoogleSignIn

final class ViewController: UIViewController {
    
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
    }
    
    @objc
    func tabGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
          guard error == nil else { return }
            //TODO: 로그인 성공적으로 받아지면 실행되는 main View 담아주는 곳.
          // If sign in succeeded, display the app's main content View.
            
            guard let signInResult = signInResult else { return }
            
            let user = signInResult.user
            let emailAddress = user.profile?.email
            let fullName = user.profile?.name
            let givenName = user.profile?.givenName
            let familyName = user.profile?.familyName
            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            
            let idtoken = user.idToken?.tokenString
            let accesstoken = user.accessToken.tokenString
            let refreshtoken = user.refreshToken.tokenString
        }
    }
}
