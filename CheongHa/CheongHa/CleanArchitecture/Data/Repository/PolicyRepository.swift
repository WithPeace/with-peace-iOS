//
//  PolicyRepository.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/19/24.
//

import Foundation
import RxMoya
import RxSwift

protocol PolicyRepositoryProtocol {
    func fetchHotPolicies(api: PolicyRouter) -> Single<PolicyDTO>
    func fetchRecommendedPolicies(api: PolicyRouter) -> Single<PolicyDTO>
    func fetchPolicies(api: PolicyRouter) -> Single<PolicyDTO>
    func fetchPolicy(api: PolicyRouter) -> Single<PolicyDetailDTO>
}

final class PolicyRepository: PolicyRepositoryProtocol {

    private let keychain: KeychainManagerProtocol
    private let network: NetworkManagerProtocol
    
    init(keychain: KeychainManagerProtocol, network: NetworkManagerProtocol) {
        self.keychain = keychain
        self.network = network
    }
    
    func fetchHotPolicies(api: PolicyRouter) -> Single<PolicyDTO> {
        network
            .request(api, decodingType: PolicyDTO.self)
    }
    
    func fetchRecommendedPolicies(api: PolicyRouter) -> RxSwift.Single<PolicyDTO> {
        network
            .request(api, decodingType: PolicyDTO.self)
    }
    
    func fetchPolicies(api: PolicyRouter) -> Single<PolicyDTO> {
        network
            .request(api, decodingType: PolicyDTO.self)
    }
    
    func fetchPolicy(api: PolicyRouter) -> Single<PolicyDetailDTO> {
        network
            .request(api, decodingType: PolicyDetailDTO.self)
    }
}
