//
//  PostImagesCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PostImagesCell: UITableViewCell {
    
    private lazy var selectedImagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.register(SelectedImageCell.self, forCellWithReuseIdentifier: SelectedImageCell.identifier)
        return collectionView
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func configureConstraints() {
        contentView.addSubview(selectedImagesCollectionView)
        
        selectedImagesCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(122)
        }
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(118),
            heightDimension: .estimated(122)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(122)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func bind() {
        Observable.just([1,2,3,4,5])
            .bind(to: selectedImagesCollectionView.rx.items(cellIdentifier: SelectedImageCell.identifier, cellType: SelectedImageCell.self)) { index, item, cell in
                
            }
            .disposed(by: disposeBag)
    }
}
