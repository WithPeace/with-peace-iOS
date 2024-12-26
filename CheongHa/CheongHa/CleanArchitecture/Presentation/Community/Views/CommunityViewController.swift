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
import RxAppState

final class CommunityViewController: UIViewController {
    
    private let baseContainer = UIView()
    private let tabBarContainer = UIView()
    private var communityTabButtons: [CommunityTabButton] = []
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
    
    private let viewModel: CommunityViewModel
    
    init(viewModel: CommunityViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        view.backgroundColor = .white
        view.addSubview(baseContainer)
        view.addSubview(indicatorBar)

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        baseContainer.pin.all(view.pin.safeArea)
        baseContainer.flex.layout()
        tabBarContainer.flex.layout()
        
        layoutIndicatorBar()
    }

    private func layoutIndicatorBar() {
        let selectedCategoryIndex = viewModel.selectedCategoryIndexRelay.value
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
        
        let input = CommunityViewModel.Input(
            viewDidLoad: Observable.just(())
        )
        let output = viewModel.transform(input: input)
        
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
        
        output.posts
            .drive(collectionView.rx.items(cellIdentifier: CommunityPostCollectionViewCell.identifier, cellType: CommunityPostCollectionViewCell.self)) { index, item, cell in
                cell.setData(with: item)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(PostData.self)
            .bind(with: self) { owner, selectedItem in
                let communityDetailVC = CommunityDetailViewController(
                    viewModel: CommunityDetailViewModel(
                        postUsecase: PostUsecase(
                            postRepository: PostRepository(
                                keychain: KeychainManager(),
                                network: CleanNetworkManager()
                            )
                        ),
                        selectedPostId: selectedItem.postId
                    )
                )
                owner.navigationController?.pushViewController(communityDetailVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func tabTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedCategory = sender.view else { return }
        let newIndex = tappedCategory.tag
        
        viewModel.selectedCategoryIndexRelay.accept(newIndex)
        print(viewModel.selectedCategoryIndexRelay.value)
        
        // UI 업데이트
        updateCommunityTabsUI()
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            layoutIndicatorBar()
        }
    }
    
    private func updateCommunityTabsUI() {
        self.communityTabButtons = self.communityTabButtons.map {
            let selectedCategoryIndex = viewModel.selectedCategoryIndexRelay.value
            if $0.tag == selectedCategoryIndex, let selectedCategory = CommunityCategory(rawValue: selectedCategoryIndex) {
                $0.categoryIconView.image = UIImage(resource: selectedCategory.iconSelectedImage)
                $0.categoryLabel.textColor = .mainPurple
            } else if $0.tag != selectedCategoryIndex, let selecteCategory = CommunityCategory(rawValue: $0.tag) {
                $0.categoryIconView.image = UIImage(resource: selecteCategory.iconNotSelectedImage)
                $0.categoryLabel.textColor = .gray2
            }
            return $0
        }
    }
}

