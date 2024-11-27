//
//  PostUsecase.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/19/24.
//

import Foundation
import RxSwift

protocol PostUsecaseProtocol {
    func fetchRecentPosts() -> Single<CleanPostDTO>
}

final class PostUsecase: PostUsecaseProtocol {

    private let postRepository: PostRepositoryProtocol
    
    init(postRepository: PostRepositoryProtocol ) {
        self.postRepository = postRepository
    }
    
    func fetchRecentPosts() -> Single<CleanPostDTO> {
        return postRepository.fetchRecentPosts(api: .fetchRecentPosts)
    }
}
