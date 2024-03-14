//
//  ViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/7/24.
//

import UIKit
import GoogleSignIn

final class ViewController: UIViewController {
    private let googleManager = GoogleSignInManager()
    
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
//        googleManager.aaa(view: self)
    }
}


/*
 View
    >login
    >tabbar
    >contentsview
        >home
        >forum
        >add
        >profile
 */
