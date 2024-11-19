//
//  HomeViewModel.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    struct Input {
        let viewWillAppearTrigger: Observable<Bool>
    }
    
    struct Output {

    }
    
    private let policyUsecase: PolicyUsecaseProtocol
    private let postUsecase: PostUsecaseProtocol
    
    init(
        policyUsecase: PolicyUsecaseProtocol,
        postUsecase: PostUsecaseProtocol
    ) {
        self.policyUsecase = policyUsecase
        self.postUsecase = postUsecase
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input
            .viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
//                owner.policyUsecase.fetchRecommendedPolicies()
                owner.postUsecase.fetchRecentPosts()
            }
            .map {
                print(">>>>>>>>>>>>", $0)
                return $0.data
            }
            .subscribe { _ in
                
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
