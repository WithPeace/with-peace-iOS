//
//  CommunityDetailViewModel.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/26/24.
//

import RxSwift
import RxCocoa

typealias CommunityDetailDatasType = [CommunityDetailSection: [CommunityDetailSectionItem]]

final class CommunityDetailViewModel: ViewModelType {
        
    private let sectionsRelay = PublishRelay<CommunityDetailDatasType>()
    
    struct Input {
        let viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        let sections: Driver<CommunityDetailDatasType>
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
                let postDetailItemData = CommunityDetailSectionDataCollection.PostDetailItemData(
                    postId: postDetail.postId,
                    userId: postDetail.userId,
                    nickname: postDetail.nickname,
                    profileImageUrl: postDetail.profileImageUrl ?? "",
                    title: postDetail.title,
                    content: postDetail.content,
                    type: postDetail.type,
                    createDate: postDetail.createDate,
                    postImageUrls: postDetail.postImageUrls,
                    commentCount: postDetail.comments.count
                )
                                
                let commenItemsData = postDetail.comments.map {
                    let commentItemData = CommunityDetailSectionDataCollection.CommentItemData(
                        commentId: $0.commentId,
                        userId: $0.userId,
                        nickname: $0.nickname,
                        profileImageUrl: $0.profileImageUrl ?? "",
                        content: $0.content,
                        createDate: $0.createDate
                    )
                    return  CommunityDetailSectionItem.comment(data: .init(commentData: commentItemData))
                }
                
                let postDetailData: CommunityDetailDatasType = [
                    .post: [.post(data: .init(postDetailData: postDetailItemData))],
                    .comment: commenItemsData
                ]
                
                owner.sectionsRelay.accept(postDetailData)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        Output(
            sections: sectionsRelay.asDriver(onErrorJustReturn: [:])
        )
    }
    
}
