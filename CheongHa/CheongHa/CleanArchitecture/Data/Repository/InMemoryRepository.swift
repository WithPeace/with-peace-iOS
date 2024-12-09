//
//  InMemoryRepository.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/26/24.
//

import Foundation
import RxSwift

protocol InMemoryRepositoryProtocol {
    func save(key: InMemonryStorageKey, value: SelectedFilterTagsDTO)
    func fetch(key: InMemonryStorageKey) -> Observable<SelectedFilterTagsDTO?>
}

final class InMemoryRepository: InMemoryRepositoryProtocol {
    
    private let inMemoryManager: InMemoryManager

    init() { self.inMemoryManager = .shared }
    
    func save(key: InMemonryStorageKey, value: SelectedFilterTagsDTO) {
        inMemoryManager.save(key: key, value: value)
    }
    
    func fetch(key: InMemonryStorageKey) -> Observable<SelectedFilterTagsDTO?> {
        return Observable.just(inMemoryManager.fetch(key: key))
    }
}
