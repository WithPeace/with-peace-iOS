//
//  LoginNickNameViewModel.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import Foundation
import RxSwift

final class LoginNickNameViewModel {
    enum State {
        case success
        case empty
        case notEnoughCharacters
        case exceededCharacters
        case duplication
        case otherCharacters
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
            case .duplication:
                "중복된 닉네임 입니다"
            case .otherCharacters:
                "닉네임은 2~10자의 한글, 영문만 가능합니다."
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
            case .unknown:
                false
            }
        }
    }
    
    let disposeBag = DisposeBag()
    
    //INPUT
    var nicknameField: BehaviorSubject<String?>
    var profileImage: PublishSubject<Data?>
    var tapRegisterButton: BehaviorSubject<Void>
    
    //OUTPUT
    var isNicknameValid: Observable<State> // 닉네임이 유효한지?
    
    var changeProfileImage: Observable<Data?>
    var dismissForNext: Observable<State>
    
    init() {
        
        //INPUT
        self.nicknameField = BehaviorSubject<String?>(value: "")
        self.profileImage = PublishSubject<Data?>()
        self.tapRegisterButton = BehaviorSubject<Void>(value: Void())
        
        //OUTPUT
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
                
                //TODO: 서버 닉네임 중복 확인. 임시구현
                if nickname == "abc" { return .duplication }
                
                return .success
            }
        
        self.changeProfileImage = profileImage
            .map { data in
                if let data = data { return data }
                
                return nil
            }
        
        dismissForNext = tapRegisterButton.withLatestFrom(isNicknameValid)
    }
}
