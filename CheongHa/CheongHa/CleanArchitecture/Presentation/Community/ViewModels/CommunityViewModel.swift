//
//  CommunityViewModel.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/25/24.
//

import RxSwift
import RxCocoa

final class CommunityViewModel: ViewModelType {
    
    let selectedCategoryIndexRelay = BehaviorRelay<Int>(value: 0)
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let posts: Driver<[PostData]>
    }
    
    var disposeBag = DisposeBag()
    
    private let postUsecase: PostUsecaseProtocol
    
    init(postUsecase: PostUsecaseProtocol) {
        self.postUsecase = postUsecase
    }
    
    func transform(input: Input) -> Output {
        let postsRelay = PublishRelay<[PostData]>()
        
        input.viewDidLoad
            .bind(with: self) { owner, _ in
                /// 초기값은 자유 카테고리 이벤트 발생
                owner.selectedCategoryIndexRelay.accept(0)
            }
            .disposed(by: disposeBag)
        
        selectedCategoryIndexRelay
            .map { initialIndex in
                FetchPostsQuery(type: CommunityCategory(rawValue: initialIndex)?.convertToPostType.rawValue ?? "FREEDOM", pageIndex: 0, pageSize: 10)
            }
            .withUnretained(self)
            .flatMap { owner, query in
                owner.postUsecase.fetchPosts(with: query)
            }
            .map { $0.data }
            .compactMap { $0 }
            .subscribe { posts in
                print("posts", posts)
                postsRelay.accept(posts)
            }
            .disposed(by: disposeBag)
        
        return Output(posts: postsRelay.asDriver(onErrorJustReturn: []))
    }
}
