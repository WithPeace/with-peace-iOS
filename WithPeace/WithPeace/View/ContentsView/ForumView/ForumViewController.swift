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
//    private var displayedPosts: [PostModel] = []
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
        selectedCategory
            .subscribe(onNext: { [weak self] category in
                self?.loadPosts(for: category)
            })
            .disposed(by: disposeBag)
        
        // CategoryView의 카테고리 선택 이벤트를 selectedCategory에 바인딩
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
            guard let category = category else { return true } // 카테고리가 선택되지 않았으면 모든 게시물을 표시
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
    //    func numberOfSections(in collectionView: UICollectionView) -> Int { return 2 }
}

final class ForumCategoryView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let highlightSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var separatorWidthConstraint: NSLayoutConstraint?
    private var separatorLeadingConstraint: NSLayoutConstraint?
    private var selectedButtonIndex: Int?
    var onCategorySelected: ((Category) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupCategoryButton()
        setupSeparatorView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        self.backgroundColor = .systemBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            self.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    private func setupCategoryButton() {
        for (index, category) in Category.allCases.enumerated() {
            let button = UIButton()
            button.setTitle(category.rawValue, for: .normal)
            button.setImage(UIImage(named: category.imageName), for: .normal)
            button.setImage(UIImage(named: category.selectedImageName), for: .selected)
            button.tag = index
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setupSeparatorView() {
        self.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 2),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
        ])
        
        self.addSubview(highlightSeparatorView)
        separatorWidthConstraint = highlightSeparatorView.widthAnchor.constraint(equalToConstant: 0)
        separatorLeadingConstraint = highlightSeparatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        NSLayoutConstraint.activate([
            highlightSeparatorView.topAnchor.constraint(equalTo: separatorView.topAnchor),
            separatorLeadingConstraint!,
            separatorWidthConstraint!,
            highlightSeparatorView.heightAnchor.constraint(equalTo: separatorView.heightAnchor),
        ])
    }
    
    @objc func categoryButtonTapped(_ sender: UIButton) {
        //        let title = sender.title(for: .normal),
        //              let category = Category(rawValue: title),
        guard let index = stackView.arrangedSubviews.firstIndex(of: sender) else { return }
        
        selectedButtonIndex = sender.tag
        updateSeparatorPosition(index: sender.tag)
        
        if let category = Category(rawValue: sender.title(for: .normal) ?? "") {
            onCategorySelected?(category)
        }
    }
    
    private func updateSeparatorPosition(index: Int) {
        let button = stackView.arrangedSubviews[index]
        
        separatorLeadingConstraint?.constant = button.frame.minX + stackView.frame.minX
        separatorWidthConstraint?.constant = button.frame.width
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}
