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
    private var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeSectionItem>()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel: HomeViewModel
    
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
        
        bind()
        cellRegistration()
        
        snapshot.appendSections(HomeSection.allCases)
        update(section: .myKeywords, items: [
            .myKeywords(data: .init(myKeywordsData: "menu")),
            .myKeywords(data: .init(myKeywordsData: "#DeclarativeUI")),
            .myKeywords(data: .init(myKeywordsData: "UIKit")),
            .myKeywords(data: .init(myKeywordsData: "#ModernConcurrency")),
            .myKeywords(data: .init(myKeywordsData: "#SwiftUI")),
            .myKeywords(data: .init(myKeywordsData: "#CoreData")),
            .myKeywords(data: .init(myKeywordsData: "#Combine")),
            .myKeywords(data: .init(myKeywordsData: "#Combine")),
            .myKeywords(data: .init(myKeywordsData: "#ModernConcurrency")),
        ])
        update(section: .hotPolicy, items: [
            .hotPolicy(data: .init(hotPolicyData: .init(thumnail: "1", description: "@"))),
            .hotPolicy(data: .init(hotPolicyData: .init(thumnail: "2", description: "3"))),
            .hotPolicy(data: .init(hotPolicyData: .init(thumnail: "123", description: "124"))),
        ])
        update(section: .policyRecommendation, items: [
            .policyRecommendation(data: .init(hotPolicyData: .init(thumnail: "123", description: "444"))),
            .policyRecommendation(data: .init(hotPolicyData: .init(thumnail: "122", description: "441234"))),
            .policyRecommendation(data: .init(hotPolicyData: .init(thumnail: "1243", description: "443214")))
        ])
        update(section: .community, items: [
            .community(data: .init(communityData: .init(title: "sdf", recentPostTitle: "SDsdf"))),
            .community(data: .init(communityData: .init(title: "a32", recentPostTitle: "SDsdf"))),
            .community(data: .init(communityData: .init(title: "23", recentPostTitle: "SDsdf"))),
            .community(data: .init(communityData: .init(title: "s2434df", recentPostTitle: "SDsdf"))),
            .community(data: .init(communityData: .init(title: "sdf", recentPostTitle: "SDs234df"))),
            .community(data: .init(communityData: .init(title: "sdf", recentPostTitle: "SDs234df"))),
            .community(data: .init(communityData: .init(title: "sdf", recentPostTitle: "SDs234df"))),
            .community(data: .init(communityData: .init(title: "sdf", recentPostTitle: "SDs234df"))),
        ])
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
    
    private func bind() {
        
        let input = HomeViewModel.Input(viewWillAppearTrigger: rx.viewWillAppear)
        
        let output = viewModel.transform(input: input)
    }
    
    private func update(section: HomeSection, items: [HomeSectionItem]) {
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
