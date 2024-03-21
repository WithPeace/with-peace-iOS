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
    var profileImage: BehaviorSubject<Data>?
    
    //OUTPUT
    var isNicknameValid: Observable<Bool> //닉네임이 유효한지?
//    var isNicknameDuplicated: Observable<Bool>
    
    init() {
        let nicknameField = BehaviorSubject<String?>(value: "")
        
        self.nicknameField = nicknameField
        
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
        
        // 중복은 isnicknameValid 스트림에서 true일 때 가져옴
//        self.isNicknameDuplicated
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
