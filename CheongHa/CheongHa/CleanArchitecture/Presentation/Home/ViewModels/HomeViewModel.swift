//
//  HomeViewModel.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/11/24.
//

import Foundation
import RxSwift
import RxCocoa

typealias HomeDatasType = (hotPolicies: [HomeSectionItem]?, recommendedPolicies: [HomeSectionItem]?, recentPosts: [HomeSectionItem]?)

final class HomeViewModel: ViewModelType {
    struct Input {
        let viewWillAppearTrigger: Observable<Bool>
    }
    
    struct Output {
        let homeDatas: Driver<HomeDatasType>
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
                return $0.data?.compactMap({
                    HomeSectionItem.hotPolicy(data: .init(hotPolicyData: .init(thumnail: $0.classification.policyImage, description: $0.introduce)))
                })
            }
        
        let recommendedPolicies = input
            .viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.policyUsecase.fetchRecommendedPolicies()
            }
            .map {
                print("recommendedPolicies 통과")
                return $0.data?.compactMap({
                    HomeSectionItem.policyRecommendation(data: .init(policyRecommendationData: .init(thumnail: $0.classification.policyImage, description: $0.introduce)))
                    
                })
            }
        
        let recentPosts = input
            .viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.postUsecase.fetchRecentPosts()
            }
            .map {
                print("recentPosts 통과")
                return $0.data?.compactMap {
                    HomeSectionItem.community(data: .init(communityData: .init(title: $0.type.postTitle, recentPostTitle: $0.title)))
                }
            }
        
        let homeDatas = Observable.zip(hotPolicies, recommendedPolicies, recentPosts, resultSelector: { hotPolicies, recommendedPolicies, recentPosts -> HomeDatasType in
            print("완료")
            return (hotPolicies, recommendedPolicies, recentPosts)
        })
        
        return Output(
            homeDatas: homeDatas.asDriver(onErrorJustReturn: (nil, nil, nil))
        )
    }
}
