//
//  CommunityDetailViewController.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/22/24.
//

import UIKit
import PinLayout
import FlexLayout
import Kingfisher
import RxSwift
import RxCocoa

enum CommunityDetailSection: Int, CaseIterable {
    case postAndComment = 0
}

struct CommentItem: Identifiable, Hashable {
    let id: Int
    let userId: Int
    let profileImageURL: String
    let nickname: String
    let content: String
    let createDate: String
}

final class CommunityDetailViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    private var dataSource: UICollectionViewDiffableDataSource<CommunityDetailSection, CommentItem>!
            
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        cellRegistration()
        apply([
            CommentItem(id: 1, userId: 2, profileImageURL: "sdfsdf", nickname: "sdfsdfse", content: "esfsese", createDate: "sdfsdfsdf"),
            CommentItem(id: 2, userId: 2, profileImageURL: "sdfsdf", nickname: "sdfsdfse", content: "esfsese", createDate: "sdfsdfsdf"),
            CommentItem(id: 3, userId: 2, profileImageURL: "sdfsdf", nickname: "sdfsdfse", content: "esfsese", createDate: "sdfsdfsdf"),
            CommentItem(id: 4, userId: 2, profileImageURL: "sdfsdf", nickname: "sdfsdfse", content: "esfsese", createDate: "sdfsdfsdf"),
            CommentItem(id: 5, userId: 2, profileImageURL: "sdfsdf", nickname: "sdfsdfse", content: "esfsese", createDate: "sdfsdfsdf"),
        ])
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.pin.all()
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(70)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(70)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(524)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: CommunityDetailCollectionViewHeader.kind,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func cellRegistration() {

        let postAndCommentSectionRegistration = UICollectionView.CellRegistration<CommentCell, CommentItem> { cell, indexPath, itemIdentifier in
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = CommunityDetailSection(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .postAndComment:
                let cell = collectionView.dequeueConfiguredReusableCell(using: postAndCommentSectionRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
        })
        
        // 헤더 등록
        let communityDetailCollectionViewHeaderRegistration = UICollectionView.SupplementaryRegistration<CommunityDetailCollectionViewHeader>(elementKind: CommunityDetailCollectionViewHeader.kind) { supplementaryView, elementKind, indexPath in
            
        }
        
        dataSource.supplementaryViewProvider = { [weak self] view, kind, indexPath in
            guard let self else { return nil }
            
            switch kind {
            case CommunityDetailCollectionViewHeader.kind:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: communityDetailCollectionViewHeaderRegistration,
                    for: indexPath)
            default: return nil
            }
        }
    }
    
    private func apply(_ items: [CommentItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<CommunityDetailSection, CommentItem>()
        snapshot.appendSections(CommunityDetailSection.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot) // reloadData
    }
    
    private func bind() {
       
    }
}
