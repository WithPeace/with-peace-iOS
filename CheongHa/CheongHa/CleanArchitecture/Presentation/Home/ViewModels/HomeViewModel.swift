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
        let sendCurrentFilterKeywordsTap: Observable<Void>
        let filterVCDismissedSignal: Observable<Void>
    }
    
    struct Output {
        let homeDatas: Driver<HomeDatasType>
        let selectedFilterKeywords: Driver<[HomeSectionItem]>
    }
    
    private let policyUsecase: PolicyUsecaseProtocol
    private let postUsecase: PostUsecaseProtocol
    private let filterUsecase: FilterUsecaseProtocol
    
    init(
        policyUsecase: PolicyUsecaseProtocol,
        postUsecase: PostUsecaseProtocol,
        filterUsecase: FilterUsecaseProtocol
    ) {
        self.policyUsecase = policyUsecase
        self.postUsecase = postUsecase
        self.filterUsecase = filterUsecase
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let selectedFilterKeywords = PublishRelay<[HomeSectionItem]>()
        
        let viewWillAppearTrigger = input.viewWillAppearTrigger
            .map { _ in () }
            .asObservable()
        
        let updateHome = Observable.merge(viewWillAppearTrigger, input.filterVCDismissedSignal)
        
        let hotPolicies = updateHome
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
        
        let recommendedPolicies = updateHome
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
        
        let recentPosts = updateHome
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
        
        updateHome
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.filterUsecase.fetchPolicyFilering()
            }
            .bind { currentPolicyFiltering in
                guard let data = currentPolicyFiltering.data else { return }
                let filterTag = [HomeSectionItem.myKeywords(data: .init(myKeywordsData: "filter"))]
                let savedPolicyTags = data.classification.map { HomeSectionItem.myKeywords(data: .init(myKeywordsData: $0.policyName)) }
                let savedRegionTags = data.region.map { HomeSectionItem.myKeywords(data: .init(myKeywordsData: $0)) }
                selectedFilterKeywords.accept(filterTag + savedPolicyTags + savedRegionTags)
            }
            .disposed(by: disposeBag)
        
        return Output(
            homeDatas: homeDatas.asDriver(onErrorJustReturn: (nil, nil, nil)),
            selectedFilterKeywords: selectedFilterKeywords.asDriver(onErrorJustReturn: [])
        )
    }
}
