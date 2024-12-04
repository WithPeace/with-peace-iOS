//
//  HomeViewModel.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/11/24.
//

import Foundation
import RxSwift
import RxCocoa

typealias HomeDatasType = [HomeSection: [HomeSectionItem]]

final class HomeViewModel: ViewModelType {
    
    private let sections = BehaviorRelay<HomeDatasType>(value: [:])
    
    struct Input {
        let viewWillAppearTrigger: Observable<Bool>
        let sendCurrentFilterKeywordsTap: Observable<Void>
        let filterVCDismissedSignal: Observable<Void>
    }
    
    struct Output {
        let homeDatas: Driver<HomeDatasType>
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
        
        let selectedFilterKeywordsSubject = PublishSubject<[HomeSectionItem]>()
        let hotPoliciesSubject = PublishSubject<[HomeSectionItem]>()
        let recommendedPoliciesSubject = PublishSubject<[HomeSectionItem]>()
        let recentPostsSubject = PublishSubject<[HomeSectionItem]>()
        
        let viewWillAppearTrigger = input.viewWillAppearTrigger
            .map { _ in () }
            .asObservable()
        
        let updateHome = Observable.merge(viewWillAppearTrigger, input.filterVCDismissedSignal)
        
        viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.policyUsecase.fetchHotPolicies()
            }
            .bind {
                print("hotPolicies 통과")
                guard let data = $0.data else { return }
                let hotPolicies = data.map {
                    HomeSectionItem.hotPolicy(data: .init(hotPolicyData: .init(thumnail: $0.classification.policyImage, title: $0.title)))
                }
                hotPoliciesSubject.onNext(hotPolicies)
            }
            .disposed(by: disposeBag)
        
        updateHome
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.policyUsecase.fetchRecommendedPolicies()
            }
            .bind {
                print("recommendedPolicies 통과")
                guard let data = $0.data else { return }
                let recommendedPolicies = data.map {
                    HomeSectionItem.policyRecommendation(data: .init(policyRecommendationData: .init(thumnail: $0.classification.policyImage, title: $0.title)))
                }
                recommendedPoliciesSubject.onNext(recommendedPolicies)
            }
            .disposed(by: disposeBag)
        
        viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.postUsecase.fetchRecentPosts()
            }
            .bind {
                print("recentPosts 통과")
                guard let data = $0.data else { return }
                let recentPosts = data.compactMap {
                    HomeSectionItem.community(data: .init(communityData: .init(title: $0.type.postTitle, recentPostTitle: $0.title)))
                }
                recentPostsSubject.onNext(recentPosts)
            }
            .disposed(by: disposeBag)
        
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
                selectedFilterKeywordsSubject.onNext(filterTag + savedPolicyTags + savedRegionTags)
            }
            .disposed(by: disposeBag)
        
        let homeDatas = Observable.combineLatest(selectedFilterKeywordsSubject, hotPoliciesSubject, recommendedPoliciesSubject, recentPostsSubject) {
            (selectedFilterKeywords: $0, hotPolicies: $1, recommendedPolicies: $2, recentPosts: $3)
        }
            .withUnretained(self)
            .map { owner, updatedHomeDatas in
                let updatedSections: HomeDatasType = [
                    .myKeywords: updatedHomeDatas.selectedFilterKeywords,
                    .hotPolicy: updatedHomeDatas.hotPolicies,
                    .policyRecommendation: updatedHomeDatas.recommendedPolicies,
                    .community: updatedHomeDatas.recentPosts,
                    
                ]
                return updatedSections
            }
        
        return Output(
            homeDatas: homeDatas.asDriver(onErrorJustReturn: [:])
        )
    }
}
