//
//  LoginNickNameViewModel.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import Foundation
import RxSwift
import UIKit

final class LoginNickNameViewModel {
    enum State {
        case success
        case empty
        case notEnoughCharacters
        case exceededCharacters
        case otherCharacters
        case textSuccess
        case duplication
        case unknown
        
        var description: String {
            switch self {
            case .success:
                ""
            case .empty:
                ""
            case .notEnoughCharacters:
                "닉네임은 2~10자의 한글, 영문만 가능합니다."
            case .exceededCharacters:
                "닉네임은 2~10자의 한글, 영문만 가능합니다."
            case .otherCharacters:
                "닉네임은 2~10자의 한글, 영문만 가능합니다."
            case .textSuccess:
                ""
            case .duplication:
                "중복된 닉네임입니다."
            case .unknown:
                ""
            }
        }
        
        var isError: Bool {
            switch self {
            case .success:
                false
            case .empty:
                true
            case .notEnoughCharacters:
                true
            case .exceededCharacters:
                true
            case .duplication:
                true
            case .otherCharacters:
                true
            case .textSuccess:
                false
            case .unknown:
                false
            
            }
        }
    }
    
    let profileRepository = ProfileAPIRepository()
    let signRepository = SignRepository()
    let disposeBag = DisposeBag()
    
    //INPUT
    var nicknameField: BehaviorSubject<String?>
    var profileImage: BehaviorSubject<Data?>
    var tapRegisterButton: BehaviorSubject<Void>
    
    //OUTPUT
    var isNicknameValid: Observable<State>
    var changeProfileImage: Observable<Data?>
    var dismissForNext: Observable<State>
    var checkingDuplication: BehaviorSubject<State>
    var allSuccess = BehaviorSubject(value: false)
    
    init() {
        
        //INPUT
        self.nicknameField = BehaviorSubject<String?>(value: "")
        self.profileImage = BehaviorSubject<Data?>(value: nil)
        self.tapRegisterButton = BehaviorSubject<Void>(value: Void())
        
        //OUTPUT
        self.isNicknameValid = BehaviorSubject(value: .empty)
        
        self.changeProfileImage = profileImage
            .map { data in
                if let data = data { return data }
                
                return nil
            }
        
        self.isNicknameValid = self.nicknameField
            .map { nickname in
                guard let nickname = nickname else { return .unknown }
                
                if nickname.count == 0 {
                    return .empty
                } else if nickname.count < 2  {
                    return .notEnoughCharacters
                } else if nickname.count > 10 {
                    return .exceededCharacters
                } else if !nickname.koreaLangCheck() {
                    return .otherCharacters
                }
                
                return .textSuccess
            }
        
        checkingDuplication = BehaviorSubject(value: .empty)
        
        dismissForNext = tapRegisterButton.withLatestFrom(checkingDuplication)
        
        self.isNicknameValid
            .do(onNext: { _ in
                self.checkingDuplication.onNext(.unknown)
            })
            .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .filter({
                $0 == .textSuccess
            })
            .withLatestFrom(nicknameField)
            .subscribe(onNext: { nickname in
                guard let nickname = nickname else { return }
                self.checkDuplication(nickname: nickname)
            })
            .disposed(by: disposeBag)
        
        dismissForNext
            .filter({
                $0 == .success
            }).withLatestFrom(Observable.combineLatest(nicknameField, profileImage))
            .subscribe { nickname, imageData in
                
                let imageSize = 10 * 1024 * 1024
                var image: Data?
                guard let nickname = nickname else { return }
                
                if let imageData = imageData {
                    if imageData.count < imageSize {
                        image = UIImage(data: imageData)?.jpegData(compressionQuality: 1)
                    } else {
                        image = UIImage(data: imageData)?.jpegData(compressionQuality:  CGFloat(imageSize/imageData.count))
                    }
                    
                    self.signRepository.performRegister(nickname: nickname,
                                                        imageData: image) { result in
                        switch result {
                        case .success(_):
                            self.allSuccess.onNext(true)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func checkDuplication(nickname: String) {
        profileRepository.checkNickname(nickname: nickname) { result in
            switch result {
            case .success(let bool):
                print(bool)
                bool ? self.checkingDuplication.onNext(.duplication) : self.checkingDuplication.onNext(.success)
            case .failure(let error):
                print(error)
            }
        }
    }
}
