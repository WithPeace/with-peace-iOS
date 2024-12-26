//
//  PostRepository.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/19/24.
//

import Foundation
import RxMoya
import RxSwift

protocol PostRepositoryProtocol {
    func fetchPosts(api: PostRouter) -> Single<PostsDTO>
    func fetchAPostDetail(api: PostRouter) -> Single<PostDetailDTO>
    func fetchRecentPosts(api: PostRouter) -> Single<RecentPostDTO>
}

final class PostRepository: PostRepositoryProtocol {
    
    private let keychain: KeychainManagerProtocol
    private let network: NetworkManagerProtocol
    
    init(keychain: KeychainManagerProtocol, network: NetworkManagerProtocol) {
        self.keychain = keychain
        self.network = network
    }
    
    func fetchPosts(api: PostRouter) -> Single<PostsDTO> {
        network
            .request(api, decodingType: PostsDTO.self)
    }
    
    func fetchAPostDetail(api: PostRouter) -> Single<PostDetailDTO> {
        network
            .request(api, decodingType: PostDetailDTO.self)
    }
    
    func fetchRecentPosts(api: PostRouter) -> Single<RecentPostDTO> {
        network
            .request(api, decodingType: RecentPostDTO.self)
    }
}
