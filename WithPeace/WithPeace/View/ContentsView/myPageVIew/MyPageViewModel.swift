//
//  MyPageViewModel.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/29/24.
//

import Foundation
import UIKit
import RxSwift

final class MyPageViewModel {
    
    let signRepository = SignRepository()
    let profileRepository = ProfileAPIRepository()
    
    let disposeBag = DisposeBag()
    
    // INPUT
    let tapProfileSetupButton = PublishSubject<Void>()
    let tapLogoutButton = PublishSubject<Void>()
    let tapSignoutButton = PublishSubject<Void>()
    let viewWillAppear = PublishSubject<Void>()
    
    // OUTPUT
    var profileImage: Observable<UIImage>
    var profileNickname: Observable<String>
    var accountEmail: Observable<String>
    
    init() {
        let image = BehaviorSubject<UIImage>(value: UIImage(named: Const.Logo.MainLogo.chunghaMainLogo)!)
        let nickname = BehaviorSubject<String>(value: "cheungha")
        let email = BehaviorSubject<String>(value: "cheungha@cheungha.com")
        
        profileImage = image.distinctUntilChanged()
        profileNickname = nickname.distinctUntilChanged()
        accountEmail = email.distinctUntilChanged()
        
        // 초기 화면 데이터 Fetching (view will appear)
        viewWillAppear.bind(onNext: {
            self.profileRepository.searchProfile { result in
                switch result {
                case .success(let searchDataDTO):
                    nickname.onNext(searchDataDTO.nickname)
                    email.onNext(searchDataDTO.email)
                    
                    if let url = URL(string: searchDataDTO.profileImageUrl) {
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
        })
        .disposed(by: disposeBag)
        
        tapLogoutButton.subscribe(onNext: {
            self.signRepository.performLogout { result in
                switch result {
                case .success(_):
                    nickname.onNext("nicknamenickname")
                    email.onNext("email@email.com")
                    image.onNext(UIImage(named: Const.Logo.MainLogo.chunghaMainLogo)!)
                    
                    // TODO: User Guest등 계정 관련 Logout 진행
                case .failure(_):
                    debugPrint("LOGOUT ERROR: MyPageViewModel")
                }
            }
        })
        .disposed(by: disposeBag)
        
        //회원 탈퇴 구현
        tapSignoutButton.subscribe { _ in
            nickname.onNext("nicknamenickname")
            email.onNext("email@email.com")
            image.onNext(UIImage(named: Const.Logo.MainLogo.chunghaMainLogo)!)
        }
        .disposed(by: disposeBag)
    }
}
