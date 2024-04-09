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
    
    let profileRepository = ProfileRepository()
    let disposeBag = DisposeBag()
    
    //INPUT
    var nicknameField: BehaviorSubject<String?> //?굳이? 옵셔널? 어차피 init에서 하는데..?
    var profileImage: PublishSubject<Data?>
    var tapRegisterButton: BehaviorSubject<Void>
    
    //OUTPUT
    var isNicknameValid: Observable<State> // 닉네임이 유효한지?
    var changeProfileImage: Observable<Data?>
    var dismissForNext: Observable<State>
    var checkingDuplication: PublishSubject<State>
    
    init() {
        
        //INPUT
        self.nicknameField = BehaviorSubject<String?>(value: "")
        self.profileImage = PublishSubject<Data?>()
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
        
        checkingDuplication = PublishSubject()
        
        dismissForNext = tapRegisterButton.withLatestFrom(checkingDuplication)
        
        self.isNicknameValid
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
