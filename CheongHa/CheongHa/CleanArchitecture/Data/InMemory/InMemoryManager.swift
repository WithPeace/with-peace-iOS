//
//  InMemoryManager.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/8/24.
//

import Foundation

enum InMemonryStorageKey {
    case selectedFilterTags
}

protocol InMemoryManagerProtocol {
    func save(key: InMemonryStorageKey, value: SelectedFilterTagsDTO)
    func fetch(key: InMemonryStorageKey) -> SelectedFilterTagsDTO?
}

final class InMemoryManager {
    
    static let shared = InMemoryManager()
    
    private var inMemoryStorageForTags: [InMemonryStorageKey: SelectedFilterTagsDTO]

    private init() { inMemoryStorageForTags = [:] }
    
    func save(key: InMemonryStorageKey, value: SelectedFilterTagsDTO) {
        inMemoryStorageForTags[key] = value
    }
    
    func fetch(key: InMemonryStorageKey) -> SelectedFilterTagsDTO? {
        return inMemoryStorageForTags[key]
    }
}

