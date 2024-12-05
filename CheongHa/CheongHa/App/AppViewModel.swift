//
//  AppViewModel.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AppViewModel: ViewModelType {
    
    private let profileUsecase: ProfileUsecaseProtocol
    
    var disposeBag = DisposeBag()
    
    init(profileUsecase: ProfileUsecaseProtocol) {
        self.profileUsecase = profileUsecase
    }
        
    struct Input {
        let initializeApp: Observable<Void>
    }
    
    struct Output {
        let profile: Driver<CleanProfileDTO>
    }
    
    func transform(input: Input) -> Output {
        let profile = input.initializeApp
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.profileUsecase.fetchProfile()
            }
            .map { $0 }
            
        return Output(profile: profile.asDriver(onErrorJustReturn: CleanProfileDTO()))
    }
}
