//
//  InMemoryRepository.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/26/24.
//

import Foundation

enum InMemonryStorageKey {
    case selectedFilterTags
}

protocol InMemoryRepositoryProtocol {
    func save(key: InMemonryStorageKey, value: [String])
    func fetch(key: InMemonryStorageKey) -> [String]?
}

final class InMemoryRepository: InMemoryRepositoryProtocol {

    private var inMemoryStorageForTags: [InMemonryStorageKey: [String]] = [:]
    
    func save(key: InMemonryStorageKey, value: [String]) {
        inMemoryStorageForTags[key] = value
    }
    
    func fetch(key: InMemonryStorageKey) -> [String]? {
        return inMemoryStorageForTags[key]
    }
}
