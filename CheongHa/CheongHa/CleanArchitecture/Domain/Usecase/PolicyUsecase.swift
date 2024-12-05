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
    func fetchPolicies(with query: FetchPoliciesQuery) -> Single<PolicyDTO>
    func fetchPolicy(with params: FetchPolicyParams) -> Single<PolicyDetailDTO>
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
    
    func fetchPolicies(with query: FetchPoliciesQuery) -> Single<PolicyDTO> {
        return policyRepository.fetchPolicies(api: .fetchPolicies(query: query))
    }
    
    func fetchPolicy(with params: FetchPolicyParams) -> Single<PolicyDetailDTO> {
        return policyRepository.fetchPolicy(api: .fetchPolicy(params: params))
    }
}
