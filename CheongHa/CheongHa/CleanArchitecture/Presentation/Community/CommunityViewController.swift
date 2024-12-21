//
//  CommunityViewController.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/20/24.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift
import RxCocoa

final class CommunityViewController: UIViewController {
    
    private let baseContainer = UIView()
    private let tabBarContainer = UIView()
    private var communityTabButtons: [CommunityTabButton] = []
    private var selectedCategoryIndex: Int = 0
    private let gap: CGFloat = 20
    
    private let indicatorBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPurple
        return view
    }()
    private let indicatorBarRoad = UIView()

    private let separatorView = SeparatorView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.register(CommunityPostCollectionViewCell.self, forCellWithReuseIdentifier: CommunityPostCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        view.backgroundColor = .white
        view.addSubview(baseContainer)

        baseContainer.flex.define { flex in
            flex.addItem(tabBarContainer).direction(.column).define { flex in
                flex.addItem().direction(.row).define { flex in
                    communityTabButtons.forEach {
                        flex.addItem($0)
                    }
                }.justifyContent(.center).gap(gap)
            }.marginBottom(8)
            
            flex.addItem(separatorView).width(100%).height(2)
            flex.addItem(indicatorBarRoad).width(100%).height(2)
            
            flex.addItem(collectionView).grow(1).margin(16, 24)
        }
        
        view.addSubview(indicatorBar)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        baseContainer.pin.all(view.pin.safeArea)
        baseContainer.flex.layout()
        tabBarContainer.flex.layout()
        
        layoutIndicatorBar()
    }

    private func layoutIndicatorBar() {
        let tabWidth = communityTabButtons[selectedCategoryIndex].frame.width
        indicatorBar.pin
            .above(of: indicatorBarRoad)
            .left(communityTabButtons[selectedCategoryIndex].frame.minX)
            .width(tabWidth)
            .height(2)
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(115)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func bind() {
        
        Observable.just(CommunityCategory.allCases)
            .bind(with: self) { owner, communityCategories in
                owner.communityTabButtons = communityCategories.map {
                    let communityTabButton = CommunityTabButton(category: $0)
                    communityTabButton.isUserInteractionEnabled = true
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(owner.tabTapped))
                    communityTabButton.addGestureRecognizer(tapGesture)
                    communityTabButton.tag = $0.rawValue
                    return communityTabButton
                }
                
                owner.updateCommunityTabsUI()
            }
            .disposed(by: disposeBag)
        
        Observable.just([1,2,3,4,5,6,7,8,9,0,124,2,34,23,4])
            .bind(to: collectionView.rx.items(cellIdentifier: CommunityPostCollectionViewCell.identifier, cellType: CommunityPostCollectionViewCell.self)) { index, item, cell in
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func tabTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedCategory = sender.view else { return }
        let newIndex = tappedCategory.tag
        
        selectedCategoryIndex = newIndex
        print(selectedCategoryIndex)
        
        // UI 업데이트
        updateCommunityTabsUI()
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            layoutIndicatorBar()
        }
    }
    
    private func updateCommunityTabsUI() {
        self.communityTabButtons = self.communityTabButtons.map {
            if $0.tag == selectedCategoryIndex, let selecteCategory = CommunityCategory(rawValue: selectedCategoryIndex) {
                $0.categoryIconView.image = UIImage(resource: selecteCategory.iconSelectedImage)
                $0.categoryLabel.textColor = .mainPurple
            } else if $0.tag != selectedCategoryIndex, let selecteCategory = CommunityCategory(rawValue: $0.tag) {
                $0.categoryIconView.image = UIImage(resource: selecteCategory.iconNotSelectedImage)
                $0.categoryLabel.textColor = .gray2
            }
            return $0
        }
    }
}

