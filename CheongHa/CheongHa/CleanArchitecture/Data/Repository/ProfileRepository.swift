//
//  ProfileRepository.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/7/24.
//

import Foundation
import RxMoya
import RxSwift

// TODO: 명칭 변경 Login -> Auth
protocol ProfileRepositoryProtocol {
    func fetchProfile(api: ProfileRouter) -> Single<CleanProfileDTO>
}

final class CleanProfileRepository: ProfileRepositoryProtocol {
    
    private let keychain: KeychainManagerProtocol
    private let network: NetworkManagerProtocol
    
    init(keychain: KeychainManagerProtocol, network: NetworkManagerProtocol) {
        self.keychain = keychain
        self.network = network
    }
    
    func fetchProfile(api: ProfileRouter) -> Single<CleanProfileDTO> {
        network
            .request(api, decodingType: CleanProfileDTO.self)
    }
}
