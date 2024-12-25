//
//  PostUsecase.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/19/24.
//

import Foundation
import RxSwift

protocol PostUsecaseProtocol {
    func fetchPosts(with query: FetchPostsQuery) -> Single<PostDTO>
    func fetchRecentPosts() -> Single<RecentPostDTO>
}

final class PostUsecase: PostUsecaseProtocol {

    private let postRepository: PostRepositoryProtocol
    
    init(postRepository: PostRepositoryProtocol ) {
        self.postRepository = postRepository
    }
    
    func fetchPosts(with query: FetchPostsQuery) -> Single<PostDTO> {
        postRepository.fetchPosts(api: .fetchPosts(query: query))
    }
    
    func fetchRecentPosts() -> Single<RecentPostDTO> {
        return postRepository.fetchRecentPosts(api: .fetchRecentPosts)
    }
}
