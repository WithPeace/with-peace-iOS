//
//  FilterViewController.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/21/24.
//

import UIKit
import PinLayout
import FlexLayout
import SnapKit
import RxSwift
import RxCocoa
import RxAppState

final class FilterViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let dimmedBackView = UIView()
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var dimmedTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideBottomSheetAction))
        return tap
    }()
    
    private let containerView = UIView()
        
    private let topContainerView = UIView()
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.text = "필터"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let topSeparatorView = SeparatorView()
    private let bottomSeparatorView = SeparatorView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    private var dataSource: UICollectionViewDiffableDataSource<FilterSection, FilterTagItem>!
    
    private let bottomContainerView = UIView()
    private let cancelAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 해제", for: .normal)
        button.setTitleColor(.gray1, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        return button
    }()
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .mainPurple
        return button
    }()
    
    private let viewModel: FilterViewModel
        
    // MARK: - User Event Observables
    private let addPolicyTagRelay = PublishRelay<String>()
    private let addRegionTagRelay = PublishRelay<String>()
    let filterVCDismissSignalRelay = PublishRelay<Void>() // TODO: - 외부 VC와의 의존성 없애기, 예상: Coordinator 패턴으로 해결 예정
    
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [dimmedBackView, bottomSheetView].forEach { view.addSubview($0) }
        bottomSheetView.addSubview(containerView)
        
        dimmedBackView.backgroundColor = .clear
        bottomSheetView.backgroundColor = .white
        
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        containerView.flex.define {
            $0.addItem(topContainerView).define {
                $0.addItem(closeButton).width(24).height(24).marginRight(8)
                $0.addItem(filterLabel)
            }
            .direction(.row)
            .margin(24, 16, 16)
            $0.addItem(topSeparatorView).width(100%).height(1)
            $0.addItem(collectionView).grow(1)
            $0.addItem(bottomSeparatorView).width(100%).height(4)
            $0.addItem(bottomContainerView).direction(.row).define {
                $0.addItem(cancelAllButton)
                $0.addItem(searchButton).padding(12, 32)
            }
            .justifyContent(.spaceBetween)
            .margin(16, 24)
        }
        
        cellRegistration()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dimmedBackView.pin.all()
        bottomSheetView.pin.left().right().bottom()
        containerView.pin.all()
        containerView.flex.layout()
    }
    
    private func showBottomSheet() {
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self else { return }
            dimmedBackView.backgroundColor = .black.withAlphaComponent(0.5)
            bottomSheetView.pin.left().right().bottom().top(20%)
        })
    }
    
    /// 바텀 시트 내리기
    private func hideBottomSheet() {
        containerView.removeFromSuperview()
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self else { return }
            dimmedBackView.backgroundColor = .clear
            bottomSheetView.pin.left().right().bottom().top(100%)
        }, completion: { [weak self] _ in
            guard let self else { return }
            print("끝남")
            dismiss(animated: false)
        })
    }
    
    @objc func hideBottomSheetAction() {
        hideBottomSheet()
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(70),
                    heightDimension: .estimated(37)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(100)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 153)
                section.interGroupSpacing = 8
                
                // Header 레이아웃 생성
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: PolicyFieldHeader.identifier,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                return section
                
            } else if sectionNumber == 1 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(1)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 16, leading: 24, bottom: 0, trailing: 24)
                
                return section
            } else if sectionNumber == 2 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(70),
                    heightDimension: .estimated(37)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(100)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 75)
                section.interGroupSpacing = 8
                
                // Header 레이아웃 생성
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: RegionHeader.identifier,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                return section
            }
            return nil
        }
        
        return layout
    }
    
    private func cellRegistration() {
        let policyFieldSectionRegistration = UICollectionView.CellRegistration<PolicyFieldCollectionViewCell, FilterTagItem> { cell, indexPath, itemIdentifier in
            cell.setData(itemIdentifier)
            cell.tapGesture.rx.event
                .bind(with: self) { owner, tapGesture in
                    guard let selectedPolicyTag = cell.tagLabel.text else { return }
                    owner.addPolicyTagRelay.accept(selectedPolicyTag)
                }
                .disposed(by: cell.disposeBag)
        }
        
        let separatorSectionRegistration = UICollectionView.CellRegistration<SeparatorCell, FilterTagItem> { cell, indexPath, itemIdentifier in
        }
        
        let regionSectionRegistration = UICollectionView.CellRegistration<RegionCollectionViewCell, FilterTagItem> { cell, indexPath, itemIdentifier in
            cell.setData(itemIdentifier)
            cell.tapGesture.rx.event
                .bind(with: self) { owner, tapGesture in
                    guard let selectedRegionTag = cell.tagLabel.text else { return }
                    owner.addRegionTagRelay.accept(selectedRegionTag)
                }
                .disposed(by: cell.disposeBag)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = FilterSection(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .policyField:
                let cell = collectionView.dequeueConfiguredReusableCell(using: policyFieldSectionRegistration, for: indexPath, item: itemIdentifier)
                return cell
            case .separator:
                let cell = collectionView.dequeueConfiguredReusableCell(using: separatorSectionRegistration, for: indexPath, item: itemIdentifier)
                return cell
            case .region:
                let cell = collectionView.dequeueConfiguredReusableCell(using: regionSectionRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
        })
        
        // 헤더 등록
        let policyFieldHeaderRegistration = UICollectionView.SupplementaryRegistration<PolicyFieldHeader>(elementKind: PolicyFieldHeader.identifier) { supplementaryView, elementKind, indexPath in
        }
        
        let regionHeaderRegistration = UICollectionView.SupplementaryRegistration<RegionHeader>(elementKind: RegionHeader.identifier) { supplementaryView, elementKind, indexPath in
        }
        
        dataSource.supplementaryViewProvider = { [weak self] view, kind, indexPath in
            guard let self else { return nil }
            
            switch kind {
            case PolicyFieldHeader.identifier:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: policyFieldHeaderRegistration,
                    for: indexPath)
            case RegionHeader.identifier:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: regionHeaderRegistration,
                    for: indexPath)
            default: return nil
            }
        }
    }

    private func apply(with sections: [FilterSection: [FilterTagItem]]) {
        var snapshot = NSDiffableDataSourceSnapshot<FilterSection, FilterTagItem>()
        snapshot.appendSections(FilterSection.allCases)
        sections.forEach {
            snapshot.appendItems($0.value, toSection: $0.key)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func bind() {

        let input = FilterViewModel.Input(
            viewWillApear: rx.viewWillAppear,
            addPolicyTag: addPolicyTagRelay.asObservable(),
            addRegionTag: addRegionTagRelay.asObservable(),
            cancelAllButtonTap: cancelAllButton.rx.tap.asObservable(),
            searchButtonTap: searchButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .drive(with: self) { owner, sections in
                owner.apply(with: sections)
            }
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.hideBottomSheet()
            }
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .bind(with: self) { owner, _ in
                owner.showBottomSheet()
            }
            .disposed(by: disposeBag)
        
        output.dismissSingal
            .drive(with: self) { owner, _ in
                owner.hideBottomSheet()
                owner.filterVCDismissSignalRelay.accept(())
            }
            .disposed(by: disposeBag)
    }
}
