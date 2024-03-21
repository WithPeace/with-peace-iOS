//
//  LoginNickNameViewModel.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import Foundation
import RxSwift

final class LoginNickNameViewModel {
    
    //INPUT
    var nicknameField: BehaviorSubject<String?>
    var profileImageData: PublishSubject<Data?>
    
    //OUTPUT
    var isNicknameValid: Observable<Bool> //닉네임이 유효한지?
//    var isNicknameDuplicated: Observable<Bool>?
    
    var profileImage: Observable<Data?>
    
    init() {
        
        self.nicknameField = BehaviorSubject<String?>(value: "")
        self.isNicknameValid = self.nicknameField
            .map { nickname in
                guard let nickname = nickname else { return false }
                
                if nickname.count < 2 || nickname.count > 10 {
                    return false
                }
                
                if !nickname.koreaLangCheck() {
                    return false
                }
                // 서버 닉네임 중복 확인.
                return true
            }
        
        self.profileImageData = PublishSubject<Data?>()
        self.profileImage = profileImageData
            .map { data in
                if let data = data {
                    return data
                }
                
                return nil
            }
    }
}

extension String {

    func koreaLangCheck() -> Bool {
        let pattern = "^[가-힣a-zA-Z\\s]*$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(location: 0, length: self.utf16.count)
            if regex.firstMatch(in: self, options: [], range: range) != nil {
                return true
            }
        }
        return false
    }
}

