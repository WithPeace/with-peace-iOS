//
//  ProfileRepository.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/7/24.
//

import Foundation
import RxSwift

protocol ProfileRepositoryProtocol {
    func fetchProfile(api: ProfileRouter) -> Single<CleanProfileDTO>
    func updateProfile(api: ProfileRouter) -> Single<CleanProfileDTO>
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
    
    func updateProfile(api: ProfileRouter) -> Single<CleanProfileDTO> {
        network
            .request(api, decodingType: CleanProfileDTO.self)
    }
    
}
