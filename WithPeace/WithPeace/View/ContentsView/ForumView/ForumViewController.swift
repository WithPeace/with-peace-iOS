//
//  ForumViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import UIKit

final class ForumViewController: UIViewController {
    
    private var posts: [PostModel] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupCollectionView()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ForumPostViewCell.self, forCellWithReuseIdentifier: "ForumPostViewCell")
        collectionView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        posts.append(post)
        sortPosts()
        collectionView.reloadData()
    }
    
    private func refreshPostData() {
        sortPosts()
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func sortPosts() {
        posts.sort {$0.creationDate > $1.creationDate }
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

final class ForumCategoryViewCell: UICollectionViewCell {
    //카테고리 나열
}
