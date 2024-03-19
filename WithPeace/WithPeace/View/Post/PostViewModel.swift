//
//  PostViewModel.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import Foundation
import RxSwift

final class PostViewModel {
    let categorySelected = PublishSubject<String>()
    let titleTextChanged = PublishSubject<String>()
    let descriptionTextChanged = PublishSubject<String>()
    
    let isCompleteButtonEnabled: Observable<Bool>
    
    init() {
        let isTitleNotEmpty = titleTextChanged.asObservable().map { !$0.isEmpty }
        let isDescriptionNotEmpty = descriptionTextChanged.asObservable().map { !$0.isEmpty }
        
        isCompleteButtonEnabled = Observable.combineLatest(isTitleNotEmpty, isDescriptionNotEmpty) { $0 && $1 }
    }
}
