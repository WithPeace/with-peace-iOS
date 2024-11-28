//
//  FilterUsecase.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/28/24.
//

import Foundation
import RxSwift

protocol FilterUsecaseProtocol {
    func fetchRecentPosts() -> Single<CurrentPolicyFiltering>
}

final class FilterUsecase: FilterUsecaseProtocol {

    private let filterRepository: FilterRepositoryProtocol
    
    init(filterRepository: FilterRepositoryProtocol ) {
        self.filterRepository = filterRepository
    }
    
    func fetchRecentPosts() -> Single<CurrentPolicyFiltering> {
        return filterRepository.fetchPolicyFilering(api: .fetchPolicyFilering)
    }
}
