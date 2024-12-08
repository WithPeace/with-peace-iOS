//
//  FilterRepository.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/28/24.
//

import Foundation
import RxMoya
import RxSwift

protocol FilterRepositoryProtocol {
    func fetchPolicyFilering(api: FilterRouter) -> Single<CurrentPolicyFiltering>
    func changePolicyFilering(api: FilterRouter) -> Single<CheckFilteringChangeSuccess>
}

final class FilterRepository: FilterRepositoryProtocol {
    
    private let keychain: KeychainManagerProtocol
    private let network: NetworkManagerProtocol
    
    init(keychain: KeychainManagerProtocol, network: NetworkManagerProtocol) {
        self.keychain = keychain
        self.network = network
    }
    
    func fetchPolicyFilering(api: FilterRouter) -> Single<CurrentPolicyFiltering> {
        network
            .request(api, decodingType: CurrentPolicyFiltering.self)
    }
    
    func changePolicyFilering(api: FilterRouter) -> Single<CheckFilteringChangeSuccess> {
        network
            .request(api, decodingType: CheckFilteringChangeSuccess.self)
    }
}
