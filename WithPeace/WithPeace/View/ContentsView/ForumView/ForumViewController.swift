//
//  ForumViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import UIKit
import RxSwift

final class ForumViewController: UIViewController {
    
    private var posts: [PostModel] = []
    private var allPosts: [PostModel] = []
    private var selectedCategory = BehaviorSubject<Category?>(value: nil)
    private let disposeBag = DisposeBag()
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let refreshAction = UIAction { [weak self] _ in
            guard let self else { return }
            self.refreshPostData()
        }
        refreshControl.addAction(refreshAction, for: .valueChanged)
        return refreshControl
    }()
    private let categoryView = ForumCategoryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupCollectionView()
        bind()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        configureUI()
        sortPosts()
    }
    
    private func bind() {
        selectedCategory
            .subscribe(onNext: { [weak self] category in
                self?.loadPosts(for: category)
                self?.categoryView.previouslySelectedCategory = category?.rawValue
            })
            .disposed(by: disposeBag)
        
        categoryView.onCategorySelected = { [weak self] category in
            self?.selectedCategory.onNext(category)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        view.addSubview(collectionView)
        view.addSubview(categoryView)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ForumPostViewCell.self, forCellWithReuseIdentifier: "ForumPostViewCell")
        collectionView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 90),
            
            collectionView.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(115))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 8
            
            return section
        }
    }
    
    func addNewPost(_ post: PostModel) {
        allPosts.append(post)
        sortPosts()
        selectedCategory
            .asObservable()
            .take(1)
            .subscribe(onNext: { [weak self] category in
                self?.loadPosts(for: category)
            })
            .disposed(by: disposeBag)
    }
    
    private func refreshPostData() {
        sortPosts()
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func sortPosts() {
        posts.sort {$0.creationDate > $1.creationDate }
    }
    
    private func loadPosts(for category: Category?) {
        posts = allPosts.filter { post in
            guard let category = category else { return true }
            return post.type == category.rawValue
        }
        collectionView.reloadData()
    }
}

extension ForumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForumPostViewCell",
                                                                for: indexPath) as? ForumPostViewCell else {
            return UICollectionViewCell()
        }
        
        let post = posts[indexPath.row]
        postCell.configure(postModel: post)
        return postCell
    }
}

extension ForumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let detailVC = ForumDetailViewController()
        detailVC.postModel = post
        detailVC.onPostUpdated = { [weak self] updatedPost in
            self?.updatePost(updatedPost)
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func updatePost(_ updatedPost: PostModel) {
        if let index = posts.firstIndex(where: { $0.uuid == updatedPost.uuid }) {
            posts[index] = updatedPost
            collectionView.reloadData()
        }
    }
}
