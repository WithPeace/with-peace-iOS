//
//  CommunityDetailCollectionViewHeader.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/22/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PostUserProfileView: UIView {
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
//        let url = URL(string: "https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG")
//        imageView.kf.setImage(with: url)
        
        imageView.layer.cornerRadius = 28
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let infoContainerView = UIView()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임닉네임"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let postUploadTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "3일전"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        
        [
            userNameLabel,
            postUploadTimeLabel
        ].forEach { infoContainerView.addSubview($0) }
        
        userNameLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        postUploadTimeLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        [
            userProfileImageView,
            infoContainerView
        ].forEach { addSubview($0)}
        
        userProfileImageView.snp.makeConstraints {
            $0.size.equalTo(56)
            $0.verticalEdges.leading.equalToSuperview()
        }
        
        infoContainerView.snp.makeConstraints {
            $0.centerY.equalTo(userProfileImageView)
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
    }
}

final class PostContentContainerView: UIView {
    
    let postTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "일찌기 나는 아무것도 아니었다."
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let postContentLabel: UILabel = {
        let label = UILabel()
        label.text = "돌아가는 팽이를 보고 싶어서, 그 팽이가 온전히 내 팽이이고 싶어서, 내 속도를 그대로 빼닮은 팽이의 회전을 여유롭게 관찰하고 싶어서, 그러니까 문방구에서 막상 팽이를 사오긴 했는데 요즘 누가 팽이 돌리나 눈치 보다 땅에다가는 못 풀고 눈으로 푸는 마음, 그 눈에서 돌아가는 팽이의 마음, 그거 시 같다."
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        [
            postTitleLabel,
            postContentLabel
        ].forEach { addSubview($0) }
        
        postTitleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        postContentLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

final class CommentNumberContainerView: UIView {
    
    private let commentIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .icComment)
        return imageView
    }()
    
    let commentNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        [
            commentIconImageView,
            commentNumberLabel
        ].forEach { addSubview($0) }
        
        commentIconImageView.snp.makeConstraints {
            $0.width.equalTo(14)
            $0.height.equalTo(13)
            $0.verticalEdges.leading.equalToSuperview()
        }
        
        commentNumberLabel.snp.makeConstraints {
            $0.leading.equalTo(commentIconImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(commentIconImageView)
            $0.trailing.equalToSuperview()
        }
    }
}

final class CommunityDetailCollectionViewHeader: BaseCollectionViewCell {
    
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
    
}
