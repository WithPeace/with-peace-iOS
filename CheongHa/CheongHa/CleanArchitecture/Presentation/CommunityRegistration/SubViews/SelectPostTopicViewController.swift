//
//  SelectPostTopicViewController.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/30/24.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift
import RxCocoa
import RxAppState

final class SelectPostTopicViewController: BaseBottomSheetViewController {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "게시글의 주제를 선택해주세요"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.isScrollEnabled = false
        collectionView.register(SelectPostTopicCollectionViewCell.self, forCellWithReuseIdentifier: SelectPostTopicCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let collectionViewContainerView = UIView()
    
    private let disposBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.addSubview(collectionViewContainerView)
        
        containerView.flex.define { flex in
            flex.addItem(topLabel).marginTop(24).marginBottom(32)
            flex.addItem(collectionView).grow(1)
        }.paddingHorizontal(24)
        
        bind()
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(98),
            heightDimension: .absolute(98)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(98)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item, item]
        )
        group.interItemSpacing = .flexible(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func bind() {
        Observable.just(CommunityCategory.allCases)
            .bind(to: collectionView.rx.items(cellIdentifier: SelectPostTopicCollectionViewCell.identifier, cellType: SelectPostTopicCollectionViewCell.self)) { index, item, cell in
                cell.setDatas(item)
            }
            .disposed(by: disposBag)
        
        rx.viewDidAppear
            .bind(with: self) { owner, _ in
                owner.showBottomSheet(fromTop: 60%)
            }
            .disposed(by: disposBag)
        
        collectionView.rx.modelSelected(CommunityCategory.self)
            .bind(with: self) { owner, communityCategory in
                print("communityCategory", communityCategory.categoryName)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposBag)
    }
}
