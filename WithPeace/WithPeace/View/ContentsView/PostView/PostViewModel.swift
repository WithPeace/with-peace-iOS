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
    var postModel: PostModel?
    private var selectedCategory: String?
    private var titleText: String = ""
    private var contentText: String = ""
    private let postManager = PostManager()
    
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
            //TODO: 이미지 압축? 10메가 이하로 진행
            if let data = image.jpegData(compressionQuality: 0.6) {
                imageData.append(data)
            }
        }
        let newPost = PostModel(title: titleText, content: contentText, type: "QUESTION", imageFiles: imageData, creationDate: Date())
        postModel = newPost
        postCreatedSubject.onNext(newPost)
        uploadPost(postModel: newPost)
    }
    
    private func uploadPost(postModel: PostModel) {
        postManager.uploadPost(postModel: postModel) { result in
            switch result {
            case .success(let data):
                print("success \(data)")
            case .failure(let error):
                print("upLoad Fail \(error)")
            }
        }
    }
    
    func selectImage(_ image: UIImage) {
        selectedImages.append(image)
    }
    
    func removeSelectedImage(_ image: UIImage) {
        selectedImages.removeAll { $0 == image }
    }
}
