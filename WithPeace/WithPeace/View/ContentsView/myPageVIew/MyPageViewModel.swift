//
//  MyPageViewModel.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/29/24.
//

import Foundation
import UIKit
import RxSwift

//protocol MyPageViewModel {
//    
//}

final class MyPageViewModel {
    
    let signRepository = SignRepository()
    let profileRepository = ProfileRepository()
    
    // INPUT
    let tapProfileSetupButton = PublishSubject<Void>()
    let tapLogoutButton = PublishSubject<Void>()
    let tapSignoutButton = PublishSubject<Void>()
    
    // OUTPUT
    let profileImage: Observable<UIImage>
    let profileNickname: Observable<String>
    let accountEmail: Observable<String>
    let logout: Observable<Bool>
    
    init() {
        let image = BehaviorSubject<UIImage>(value: UIImage(named: Const.Logo.MainLogo.withpeaceLogo)!)
        let nickname = BehaviorSubject<String>(value: "nicknamenickname")
        let email = BehaviorSubject<String>(value: "email@email.com")
        
        let logoutState = PublishSubject<Bool>()
        
        //TODO: 401 로인한 오류시 작동하지 않음.
        profileRepository.searchProfile { result in
            switch result {
            case .success(let data):
                nickname.onNext(data.nickname)
                email.onNext(data.email)
                
                if let url = URL(string: data.profileImageUrl) {
                    let request = URLRequest(url: url)
                    let dataTask = URLSession.shared.dataTask(with: request) { imageData, response, error in
                        if let imageData = imageData,
                           let bindImage = UIImage(data: imageData) {
                            image.onNext(bindImage)
                        }
                    }
                    dataTask.resume()
                }
                
            case .failure(let error):
                debugPrint(error)
            }
        }
        
        profileImage = image.distinctUntilChanged()
        profileNickname = nickname.distinctUntilChanged()
        accountEmail = email.distinctUntilChanged()
        
        logout = logoutState
        
        tapLogoutButton.subscribe(onNext: {
            self.signRepository.performLogout { result in
                switch result {
                case .success(_):
                    logoutState.onNext(true)
                    break
                case .failure(_):
                    logoutState.onNext(false)
                    debugPrint("LOGOUT ERROR: MyPageViewModel")
                }
            }
        })
    }
}
