//
//  LoginNickNameViewModel.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import Foundation
import RxSwift

final class LoginNickNameViewModel {
    
    var nicknameField: BehaviorSubject<String?>
    var isNicknameValid: Observable<Bool>
    
    init() {
        let nicknameField = BehaviorSubject<String?>(value: "")
        
        self.nicknameField = nicknameField
        
        self.isNicknameValid = nicknameField
            .map { nickname in
                guard let nickname = nickname else { return false }
                if nickname.count < 2 || nickname.count > 10 {
                    return false
                } else {
                    return true
                }
            }
    }
}
