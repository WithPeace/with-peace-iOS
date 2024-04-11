//
//  PostViewModel.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import UIKit
import RxSwift

final class PostViewModel {
    let categorySelected = BehaviorSubject<String?>(value: nil)
    let titleTextChanged = PublishSubject<String>()
    let contentTextChanged = PublishSubject<String>()
    private let postCreatedSubject = PublishSubject<PostModel>()
    var postCreated: Observable<PostModel> {
        return postCreatedSubject.asObservable()
    }
    var isCompleteButtonEnabled: Observable<Bool>
    var selectedImages: [UIImage] = []
    private var postModel: [PostModel] = []
    private var selectedCategory: String?
    private var titleText: String = ""
    private var contentText: String = ""
    
    let disposeBag = DisposeBag()
    
    init() {
        isCompleteButtonEnabled = Observable
            .combineLatest(titleTextChanged.startWith(""),
                           contentTextChanged.startWith(""),
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
        
        contentTextChanged
            .subscribe { [weak self] description in
                self?.contentText = description
            }
            .disposed(by: disposeBag)
        
        categorySelected
            .subscribe { [weak self] category in
                self?.selectedCategory = category
            }
            .disposed(by: disposeBag)
    }
    
    func updatePostModel() {
        var imageData = [Data]()
        for image in selectedImages {
            if let data = image.pngData() {
                imageData.append(data)
            }
        }
        let newPost = PostModel(title: titleText, content: contentText, type: selectedCategory ?? "", imageData: imageData, creationDate: Date())
        postModel.append(newPost)
        postCreatedSubject.onNext(newPost)
        print("\(newPost) 모델")
    }
    
    func selectImage(_ image: UIImage) {
        selectedImages.append(image)
    }
}
