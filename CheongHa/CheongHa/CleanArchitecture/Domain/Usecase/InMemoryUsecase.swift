//
//  InMemoryUsecase.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/8/24.
//

import Foundation
import RxSwift

protocol InMemoryUsecaseProtocol {
    func save(key: InMemonryStorageKey, value: SelectedFilterTagsDTO)
    func fetch(key: InMemonryStorageKey) -> Observable<SelectedFilterTagsDTO>
}

final class InMemoryUsecase: InMemoryUsecaseProtocol {
   
    private let inMemoryRepository: InMemoryRepositoryProtocol
    
    init(inMemoryRepository: InMemoryRepositoryProtocol ) {
        self.inMemoryRepository = inMemoryRepository
    }
    
    func save(key: InMemonryStorageKey, value: SelectedFilterTagsDTO) {
        return inMemoryRepository.save(key: key, value: value)
    }
    
    func fetch(key: InMemonryStorageKey) -> Observable<SelectedFilterTagsDTO> {
        return inMemoryRepository.fetch(key: key).compactMap { $0 }
    }
}
