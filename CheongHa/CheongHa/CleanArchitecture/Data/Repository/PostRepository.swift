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
    func fetchRecentPosts(api: PostRouter) -> Single<CleanPostDTO>
}

final class PostRepository: PostRepositoryProtocol {
    
    private let keychain: KeychainManagerProtocol
    private let network: NetworkManagerProtocol
    
    init(keychain: KeychainManagerProtocol, network: NetworkManagerProtocol) {
        self.keychain = keychain
        self.network = network
    }
    
    func fetchRecentPosts(api: PostRouter) -> Single<CleanPostDTO> {
        network
            .request(api, decodingType: CleanPostDTO.self)
    }
}
