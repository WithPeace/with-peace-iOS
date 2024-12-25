//
//  CommunityDetailViewModel.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/26/24.
//

import RxSwift
import RxCocoa

final class CommunityDetailViewModel: ViewModelType {
    
    private let postDetailRelay = PublishRelay<PostDetailData?>()
    
    struct Input {
        let viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        let postDetail: Driver<PostDetailData?>
    }
    
    var disposeBag = DisposeBag()
    
    private let postUsecase: PostUsecaseProtocol
    
    init(postUsecase: PostUsecaseProtocol, selectedPostId: Int) {
        self.postUsecase = postUsecase
        
        Observable.just(selectedPostId)
            .map { FetchPostDetailParams(postId: $0) }
            .flatMap { params in
                postUsecase.fetchAPostDetail(params: params)
            }
            .compactMap{ $0.data }
            .subscribe(with: self) { owner, postDetail in
                owner.postDetailRelay.accept(postDetail)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        
        return Output(
            postDetail: postDetailRelay.asDriver(onErrorJustReturn: nil)
        )
    }
    
}
