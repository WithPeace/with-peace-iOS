//
//  PolicyUsecase.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/19/24.
//

import Foundation
import RxSwift

protocol PolicyUsecaseProtocol {
    func fetchHotPolicies() -> Single<PolicyDTO>
    func fetchRecommendedPolicies() -> Single<PolicyDTO>
    func fetchPolicies(api: PolicyRouter) -> Single<PolicyDTO>
}

final class PolicyUsecase: PolicyUsecaseProtocol {
    
    private let policyRepository: PolicyRepositoryProtocol
    
    init(policyRepository: PolicyRepositoryProtocol ) {
        self.policyRepository = policyRepository
    }
    
    func fetchHotPolicies() -> Single<PolicyDTO> {
        return policyRepository.fetchHotPolicies(api: .fetchHotPolicies)
    }
    
    func fetchRecommendedPolicies() -> Single<PolicyDTO> {
        return policyRepository.fetchRecommendedPolicies(api: .fetchRecommendedPolicies)
    }
    
    func fetchPolicies(api: PolicyRouter) -> Single<PolicyDTO> {
        return policyRepository.fetchPolicies(api: api)
    }
}
