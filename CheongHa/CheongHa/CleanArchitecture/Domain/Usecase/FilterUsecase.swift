//
//  FilterUsecase.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/28/24.
//

import Foundation
import RxSwift

protocol FilterUsecaseProtocol {
    func fetchPolicyFilering() -> Single<CurrentPolicyFiltering>
    func changePolicyFilering(api: FilterRouter) -> Single<CheckFilteringChangeSuccess>
}

final class FilterUsecase: FilterUsecaseProtocol {

    private let filterRepository: FilterRepositoryProtocol
    
    init(filterRepository: FilterRepositoryProtocol ) {
        self.filterRepository = filterRepository
    }
    
    func fetchPolicyFilering() -> Single<CurrentPolicyFiltering> {
        return filterRepository.fetchPolicyFilering(api: .fetchPolicyFilering)
    }
    
    func changePolicyFilering(api: FilterRouter) -> Single<CheckFilteringChangeSuccess> {
        return filterRepository.changePolicyFilering(api: api)
    }
}
