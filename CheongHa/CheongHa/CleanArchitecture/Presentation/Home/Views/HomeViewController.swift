//
//  HomeViewController.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxAppState

final class HomeViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeSectionItem>!
    
    private let disposeBag = DisposeBag()
    
    private let viewModel: HomeViewModel
    
    // MARK: - User Event Observables
    private let sendCurrentFilterKeywordsTap = PublishRelay<Void>()
    private let filterVCDismissedSignal = PublishRelay<Void>() // FilterVC가 Dismiss 되었단 완료 이벤트
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        view.backgroundColor = .white
                
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        cellRegistration()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: Const.Logo.MainLogo.cheonghaTextLogo)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(60),
                    heightDimension: .estimated(10)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(10)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 8, leading: 24, bottom: 12, trailing: 24)
                section.interGroupSpacing = 8
                
                // Header 레이아웃 생성
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(29)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: MyKeywordsHeader.identifier,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                // Background
                let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: MyKeywordsBackgroundView.identifier)
                section.decorationItems = [sectionBackgroundDecoration]
                
                return section
            } else if sectionNumber == 1 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(140),
                    heightDimension: .absolute(182)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(140),
                    heightDimension: .estimated(182)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
                
                // Header 레이아웃 생성
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: HotPolicyHeader.identifier,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                return section
            } else if sectionNumber == 2 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(140),
                    heightDimension: .absolute(182)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(140),
                    heightDimension: .estimated(182)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
                
                // Header 레이아웃 생성
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: PolicyRecommendationHeader.identifier,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                return section
            } else if sectionNumber == 3 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(21)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(21)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
                
                // Header 레이아웃 생성
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: CommunityHeader.identifier,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                return section
            } else {
                return nil
            }
        }
        
        layout.register(MyKeywordsBackgroundView.self, forDecorationViewOfKind: MyKeywordsBackgroundView.identifier)
        
        return layout
    }
    
    private func cellRegistration() {
        let myKeywordSectionRegistration = UICollectionView.CellRegistration<MyKeywordsCollectionViewCell, HomeSectionItem> { cell, indexPath, itemIdentifier in
            cell.setData(itemIdentifier.data.myKeywordsData)
            
            cell.filterButton.rx.tap.bind(with: self) { owner, _ in
                let filterVC = FilterViewController(
                    viewModel: FilterViewModel(
                        filterUsecase: FilterUsecase(
                            filterRepository: FilterRepository(
                                keychain: KeychainManager(),
                                network: CleanNetworkManager()
                            )
                        ),
                        inMemoryUsecase: InMemoryUsecase(
                            inMemoryRepository: InMemoryRepository()
                        )
                    )
                )
                
                filterVC.modalPresentationStyle = .overFullScreen
                owner.present(filterVC, animated: false)
                
                // TODO: - HomeVC에 대한 의존성 문제 해결하기, Coordinator 패턴으로 해결하기
                filterVC.filterVCDismissSignalRelay.asDriver(onErrorJustReturn: ())
                    .drive(with: self) { onwer, _ in
                        owner.filterVCDismissedSignal.accept(())
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: cell.disposeBag)
        }
        
        let hotPolicySectionRegistration = UICollectionView.CellRegistration<HotPolicyCollectionViewCell, HomeSectionItem> { cell, indexPath, itemIdentifier in
            cell.setData(itemIdentifier.data.hotPolicyData)
        }
        
        let policyRecommendationSectionRegistration = UICollectionView.CellRegistration<PolicyRecommendationCollectionViewCell, HomeSectionItem> { cell, indexPath, itemIdentifier in
            cell.setData(itemIdentifier.data.policyRecommendationData)
        }
        
        let communitySectionRegistration = UICollectionView.CellRegistration<CommunityCollectionViewCell, HomeSectionItem> { cell, indexPath, itemIdentifier in
            cell.setData(itemIdentifier.data.communityData)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = HomeSection(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .myKeywords:
                let cell = collectionView.dequeueConfiguredReusableCell(using: myKeywordSectionRegistration, for: indexPath, item: itemIdentifier)
                return cell
            case .hotPolicy:
                let cell = collectionView.dequeueConfiguredReusableCell(using: hotPolicySectionRegistration, for: indexPath, item: itemIdentifier)
                return cell
            case .policyRecommendation:
                let cell = collectionView.dequeueConfiguredReusableCell(using: policyRecommendationSectionRegistration, for: indexPath, item: itemIdentifier)
                return cell
            case .community:
                let cell = collectionView.dequeueConfiguredReusableCell(using: communitySectionRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
        })
        
        // 헤더 등록
        let myKeywordsHeaderRegistration = UICollectionView.SupplementaryRegistration<MyKeywordsHeader>(elementKind: MyKeywordsHeader.identifier) { supplementaryView, elementKind, indexPath in
            
        }
        
        let hotPolicyHeaderRegistration = UICollectionView.SupplementaryRegistration<HotPolicyHeader>(elementKind: HotPolicyHeader.identifier) { supplementaryView, elementKind, indexPath in
            
        }
        
        let policyRecommendationHeaderRegistration = UICollectionView.SupplementaryRegistration<PolicyRecommendationHeader>(elementKind: PolicyRecommendationHeader.identifier) { supplementaryView, elementKind, indexPath in
            
        }
        
        let communityHeaderRegistration = UICollectionView.SupplementaryRegistration<CommunityHeader>(elementKind: CommunityHeader.identifier) { supplementaryView, elementKind, indexPath in
            
        }
        
        dataSource.supplementaryViewProvider = { [weak self] view, kind, indexPath in
            guard let self else { return nil }
            
            switch kind {
            case MyKeywordsHeader.identifier:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: myKeywordsHeaderRegistration,
                    for: indexPath)
            case HotPolicyHeader.identifier:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: hotPolicyHeaderRegistration,
                    for: indexPath)
            case PolicyRecommendationHeader.identifier:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: policyRecommendationHeaderRegistration,
                    for: indexPath)
            case CommunityHeader.identifier:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: communityHeaderRegistration,
                    for: indexPath)
            default: return nil
            }
        }
    }
    
    private func apply(with sections: [HomeSection: [HomeSectionItem]]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeSectionItem>()
        snapshot.appendSections(HomeSection.allCases)
        sections.forEach {
            snapshot.appendItems($0.value, toSection: $0.key)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func bind() {
        
        let input = HomeViewModel.Input(
            viewWillAppearTrigger: rx.viewWillAppear,
            sendCurrentFilterKeywordsTap: sendCurrentFilterKeywordsTap.asObservable(),
            filterVCDismissedSignal: filterVCDismissedSignal.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.homeDatas
            .drive(with: self) { owner, homeDatas in
                owner.apply(with: homeDatas)
            }
            .disposed(by: disposeBag)
    }
}
