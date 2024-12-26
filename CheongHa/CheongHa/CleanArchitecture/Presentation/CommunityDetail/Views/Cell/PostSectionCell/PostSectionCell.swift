//
//  PostSectionCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/26/24.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import SnapKit

final class PostSectionCell: UICollectionViewCell {
    
    private let upperSeparatorView = SeparatorView()
    
    private let categoryTagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .icCateFreeFrame)
        return imageView
    }()
    
    private let postUserProfileView = PostUserProfileView()
    
    private let postContentContainerView = PostContentContainerView()
    
    private lazy var postImagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: tempConfigureCollectionViewLayout())
        collectionView.register(PostImageCollectionViewCell.self, forCellWithReuseIdentifier: PostImageCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let commentNumberContainerView = CommentNumberContainerView()
    
    private let containerView = UIView()
    
    private let lowerSeparatorView = SeparatorView()
    
    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
                        
        configureConstraints()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        
        bind()
    }
    
    private func configureConstraints() {
        [
            upperSeparatorView,
            categoryTagImageView,
            postUserProfileView,
            postContentContainerView,
            postImagesCollectionView,
            commentNumberContainerView
        ].forEach { containerView.addSubview($0) }
        
        [
            containerView,
            lowerSeparatorView
        ].forEach { contentView.addSubview($0) }
        
        upperSeparatorView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        categoryTagImageView.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(37)
            $0.leading.equalToSuperview()
            $0.top.equalTo(upperSeparatorView.snp.bottom).offset(8)
        }
        
        postUserProfileView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(categoryTagImageView.snp.bottom).offset(16)
        }
        
        postContentContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(postUserProfileView.snp.bottom).offset(16)
        }
        
        postImagesCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(postContentContainerView.snp.bottom).offset(16)
            $0.height.equalTo(176)
        }
        
        commentNumberContainerView.snp.makeConstraints {
            $0.top.equalTo(postImagesCollectionView.snp.bottom).offset(16)
            $0.leading.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        lowerSeparatorView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(8)
            $0.height.equalTo(4)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func tempConfigureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func bind() {
        Observable.just([1,2,3,4,5])
            .bind(to: postImagesCollectionView.rx.items(cellIdentifier: PostImageCollectionViewCell.identifier, cellType: PostImageCollectionViewCell.self)) { index, item, cell in
            }
            .disposed(by: disposeBag)
    }
    
    func setData(_ data: CommunityDetailSectionDataCollection.PostDetailItemData) {
        categoryTagImageView.image = UIImage(resource: data.type.communityDetailCategory)
        
        let defaultProfileImage = UIImage(resource: .defaultProfile)
        if data.profileImageUrl.isEmpty {
            postUserProfileView.userProfileImageView.image = defaultProfileImage
        } else {
            let imageURL = URL(string: data.profileImageUrl)
            postUserProfileView.userProfileImageView.kf.setImage(with: imageURL, placeholder: defaultProfileImage)
        }
        postUserProfileView.userNameLabel.text = data.nickname
        postUserProfileView.postUploadTimeLabel.text = data.createDate.convertToTimeAgoDate.timeAgoToDisplay
        
        postContentContainerView.postTitleLabel.text = data.title
        postContentContainerView.postContentLabel.text = data.content
        
        commentNumberContainerView.commentNumberLabel.text = data.commentCount.description
    }
    
}
