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
        
        let hotPolicies = input
            .viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.policyUsecase.fetchHotPolicies()
            }
            .map {
                print("hotPolicies 통과")
                return $0.data
            }
        
        let recommendedPolicies = input
            .viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.policyUsecase.fetchRecommendedPolicies()
            }
            .map {
                print("recommendedPolicies 통과")
                return $0.data
            }
        
        let recentPosts = input
            .viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.postUsecase.fetchRecentPosts()
            }
            .map {
                print("recentPosts 통과")
                return $0.data
            }
        
//        Observable.zip(hotPolicies, recommendedPolicies, recentPosts)
//            .subscribe { hotPolicies, recommendedPolicies, recentPosts in
//                print("완료")
//                print(">>>>>>>>>>>>>> hotPolicies")
//                print(hotPolicies)
//                
//                print("-------------------------------")
//                print(">>>>>>>>>>>>>>>>>>> recommendedPolicies")
//                print(recommendedPolicies)
//                
//                print("-------------------------------")
//                print(">>>>>>>>>>>>>>>>>>> recentPosts")
//                print(recentPosts)
//            }
//            .disposed(by: disposeBag)
        
        return Output()
    }
}
