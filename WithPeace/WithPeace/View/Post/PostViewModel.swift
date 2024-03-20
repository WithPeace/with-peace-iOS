//
//  PostViewModel.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import Foundation
import RxSwift
//import RxCocoa

final class PostViewModel {
    let categorySelected = BehaviorSubject<String?>(value: nil)
    let titleTextChanged = PublishSubject<String>()
    let descriptionTextChanged = PublishSubject<String>()
    
    var isCompleteButtonEnabled: Observable<Bool>
    private var selectedCategory: String?
    private var titleText: String = ""
    private var descriptionText: String = ""
    
    let disposeBag = DisposeBag()
    
    init() {
       isCompleteButtonEnabled = Observable
            .combineLatest(titleTextChanged.startWith(""),
                           descriptionTextChanged.startWith(""),
                           categorySelected.startWith(nil))
            .map { title, description, category in
                return !title.isEmpty && !description.isEmpty && category != nil
            }
            .distinctUntilChanged()
        
        titleTextChanged
            .subscribe { [weak self] title in
                self?.titleText = title
            }
            .disposed(by: disposeBag)
       
        descriptionTextChanged
            .subscribe { [weak self] description in
                self?.descriptionText = description
            }
            .disposed(by: disposeBag)
        
        categorySelected
            .subscribe { [weak self] category in
                self?.selectedCategory = category
            }
            .disposed(by: disposeBag)
        
    }
}
