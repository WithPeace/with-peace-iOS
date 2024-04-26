//
//  ProfileChangeViewModel.swift
//  WithPeace
//
//  Created by Dylan_Y on 4/17/24.
//

import Foundation
import RxSwift
import UIKit

final class ProfileEditViewModel {
    enum State {
        case success
        case empty
        case existingValue
        case notEnoughCharacters
        case exceededCharacters
        case otherCharacters
        case textSuccess
        case duplication
        case unknownState
        
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
            case .existingValue:
                "기존 닉네임과 동일한 닉네임입니다."
            case .unknownState:
                ""
            }
        }
        
        var isErrorColor: Bool {
            switch self {
            case .success:
                false
            case .empty:
                false
            case .notEnoughCharacters:
                true
            case .exceededCharacters:
                true
            case .duplication:
                true
            case .otherCharacters:
                true
            case .textSuccess:
                true
            case .existingValue:
                true
            case .unknownState:
                true
            }
        }
    }

    let profileRepository = ProfileRepository()
    let disposeBag = DisposeBag()
    
    //INPUT
    var nicknameField: BehaviorSubject<String?> // 변경되면 유효한지 체크해야함
    var tapProfileImage: BehaviorSubject<Data?> // 이미지가 변경되면
    var tapRegisterButton: PublishSubject<Void> // 등록버튼을 누를 때, 변경사항이 없으면 반응없고, 변경사항 있으면 alert을 띄워줌
    var tapAlertLeftButton: PublishSubject<Void> // 굳이 -> 취소하면됨
    var tapAlertRightButton: PublishSubject<Void> // 닉네임, 이미지 서버에 던지고 돌아오면 프로필뷰컨 내려줌
    
    //OUTPUT
    let isValidNickName = BehaviorSubject(value: State.empty)
    var profileImage: Observable<UIImage> // 이미지
    var differentBefore: Observable<Bool> // 기존 닉네임과 차이가 있는지?
    var toastmessage: Observable<String>
    var allSuccess = BehaviorSubject(value: false)

    init(existingNickname: String, defaultImageData: Data?) {
        //INPUT
        self.nicknameField = BehaviorSubject<String?>(value: "")
        self.tapProfileImage = BehaviorSubject<Data?>(value: defaultImageData)
        self.tapRegisterButton = PublishSubject<Void>()
        self.tapAlertLeftButton = PublishSubject<Void>()
        self.tapAlertRightButton = PublishSubject<Void>()
        
        //OUTPUT
        let toast = PublishSubject<String>()
        profileImage = tapProfileImage.asObservable()
            .map({ data in
                if let data = data,
                   let image = UIImage(data: data) {
                    return image
                }
                
                return UIImage(named: Const.CustomIcon.ICProfile.defualtProfile)!
            })
        
        let isValidText: Observable<State> = self.nicknameField
            .map { nickname in
                guard let nickname = nickname else { return .unknownState }
                
                if nickname.count == 0 {
                    return .empty
                } else if nickname.count < 2  {
                    return .notEnoughCharacters
                } else if nickname.count > 10 {
                    return .exceededCharacters
                } else if !nickname.koreaLangCheck() {
                    return .otherCharacters
                } else if existingNickname == nickname {
                    return .existingValue
                }
                
                return .textSuccess
            }
        
        differentBefore = BehaviorSubject(value: false)
        
        
        toastmessage = toast.asObservable()
        
        isValidText.filter { state in
            if state == .textSuccess {
                return true
            } else {
                self.isValidNickName.onNext(state)
                return false
            }
        }
        .withLatestFrom(nicknameField)
        .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
        .subscribe { nickname in
            guard let nickname = nickname else {
                self.isValidNickName.onNext(.unknownState)
                return
            }
            
            self.profileRepository.checkNickname(nickname: nickname) { result in
                switch result {
                case .success(let bool):
                    if bool {
                        self.isValidNickName.onNext(.duplication)
                    } else {
                        self.isValidNickName.onNext(.success)
                    }
                    print(bool)
                case .failure(let error):
                    print(error)
                }
            }
        }.disposed(by: disposeBag)
        
        differentBefore = tapRegisterButton.withLatestFrom(isValidNickName)
            .filter({ state in
                state == .success || state == .empty
            })
            .debounce(.milliseconds(100), scheduler: MainScheduler.asyncInstance)
            .withLatestFrom(Observable.combineLatest(nicknameField, tapProfileImage))
            .map({ nickname, imageData -> Bool in
                guard let nickname = nickname else { return false }
                // 닉네임, 이미지 둘중 하나라도 변경이 되었으면 true
                if let imageData = imageData {
                    if imageData == defaultImageData {
                        if nickname == existingNickname || nickname == "" {
                            toast.onNext("수정사항이 없습니다.")
                            return false
                        }
                        return true
                    } else {
                        return true
                    }
                } else {
                    if nickname == existingNickname || nickname == "" {
                        toast.onNext("수정사항이 없습니다.")
                        return false
                    }
                    return true
                }
            })
        
        tapAlertRightButton.withLatestFrom(differentBefore)
            .filter { $0 == true }
            .withLatestFrom(Observable.combineLatest(nicknameField, tapProfileImage))
            .subscribe(onNext: { nickname, imageData in
                var isNickname: Bool = false
                var isImage: Bool = false
                
                guard let nickname = nickname else { return }
                
                if nickname == existingNickname || nickname == "" {
                    isNickname = false
                } else {
                    isNickname = true
                }
                
                guard let imageData = imageData else {
                    self.change(nickname: nickname)
                    return
                }
                
                if imageData == defaultImageData {
                    isImage = false
                } else {
                    isImage = true
                }

                if isNickname && isImage {
                    self.change(nickname: nickname, imageData: imageData)
                } else if !isNickname && isImage {
                    self.change(imageData: imageData)
                } else if isNickname && !isImage {
                    self.change(nickname: nickname)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func change(imageData: Data) {
        print("이미지만")
        
        guard let resizingImage = imageSizeSetting(imageData: imageData) else {
            // TODO: Error
            return
        }
        
        profileRepository.changeProfile(imageData: resizingImage) { result in
            print("이미지만 시작")
            switch result {
            case .success(_):
                print("보내짐?")
                self.allSuccess.onNext(true)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func change(nickname: String, imageData: Data) {
        print("둘다")
        
        guard let resizingImage = imageSizeSetting(imageData: imageData) else {
            // TODO: Error
            return
        }
        
        profileRepository.changeProfile(nickname: nickname, imageData: resizingImage) { result in
            switch result {
            case .success(_):
                self.allSuccess.onNext(true)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func change(nickname: String) {
        print("닉네임만")
        
        profileRepository.changeProfile(nickname: nickname) { result in
            print("닉네임만 시작")
            switch result {
            case .success(_):
                print("보내짐?")
                self.allSuccess.onNext(true)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func imageSizeSetting(imageData: Data) -> Data? {
        var image: Data?
        let imageSize = 10 * 1024 * 1024
        
        if imageData.count < imageSize {
            image = UIImage(data: imageData)?.jpegData(compressionQuality: 1)
        } else {
            image = UIImage(data: imageData)?.jpegData(compressionQuality: CGFloat(imageSize/imageData.count))
        }
        
        return image
    }
}

