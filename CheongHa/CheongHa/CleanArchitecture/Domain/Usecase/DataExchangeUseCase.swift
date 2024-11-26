//
//  DataExchangeUseCase.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/26/24.
//

import Foundation
import RxSwift

protocol DataExchangeUseCaseProtocol {
    func saveData(key: InMemonryStorageKey, value: [String])
    func fetchData(key: InMemonryStorageKey) -> [String]
    func sendData(key: InMemonryStorageKey)
    func observeData() -> Observable<[String]>
}

final class DataExchangeUsecase: DataExchangeUseCaseProtocol {
    private let repository: InMemoryRepositoryProtocol
    private let dataSubject = PublishSubject<[String]>()
    
    init(repository: InMemoryRepositoryProtocol) {
        self.repository = repository
    }
    
    func saveData(key: InMemonryStorageKey, value: [String]) {
        repository.save(key: key, value: value)
    }
    
    func fetchData(key: InMemonryStorageKey) -> [String] {
        repository.fetch(key: key) ?? []
    }
    
    func sendData(key: InMemonryStorageKey) {
        dataSubject.onNext(fetchData(key: key))
    }
    
    func observeData() -> Observable<[String]> {
        dataSubject.asObservable()
    }
}
