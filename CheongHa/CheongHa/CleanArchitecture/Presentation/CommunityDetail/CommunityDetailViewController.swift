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

final class CommunityDetailViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    private var dataSource: UICollectionViewDiffableDataSource<CommunityDetailSection, CommentItem>!
    
    private let separatorView = SeparatorView()
    
    private lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.text = inputTextViewPlaceholderText
        textView.textColor = inputTextViewPlaceholderColor
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.backgroundColor = .clear
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    private let inputTextViewPlaceholderText = "댓글을 입력해주세요"
    private let inputTextViewPlaceholderColor: UIColor = .gray2
    private let inputTextColor: UIColor = .gray1
    
    private let sendCommentButton: UIButton = {
        let button = UIButton()
        let image = UIImage(resource: .icSend)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let inputCommentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        view.layer.cornerRadius = 21
        view.clipsToBounds = true
        return view
    }()

    private let baseContainerView = UIView()
    
    private let bottomContainerView = UIView()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        baseContainerView.addGestureRecognizer(tap)
        return tap
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(baseContainerView)
        
        updateLayout()
        
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
        
        baseContainerView.pin.all(view.pin.safeArea)
        baseContainerView.flex.layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addNotificationCenterObservers()
        
        configureNavigationBar()
        configureTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeNotificationCenterObservers()
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
        inputTextView.rx.text
            .bind(with: self) { owner, text in
                owner.adjustInputTextViewHeight()
            }
            .disposed(by: disposeBag)
        
        inputTextView.rx.didBeginEditing
            .bind(with: self) { owner, _ in
                if owner.inputTextView.text == owner.inputTextViewPlaceholderText
                    && owner.inputTextView.textColor == owner.inputTextViewPlaceholderColor {
                    owner.inputTextView.text = nil
                    let inputTextColor: UIColor = .gray1
                    owner.inputTextView.textColor = inputTextColor
                }
            }
            .disposed(by: disposeBag)
        
        inputTextView.rx.didEndEditing
            .bind(with: self) { owner, _ in
                if owner.inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    owner.inputTextView.text = owner.inputTextViewPlaceholderText
                    owner.inputTextView.textColor = owner.inputTextViewPlaceholderColor
                }
            }
            .disposed(by: disposeBag)
        
        tapGesture.rx.event
            .bind(with: self) { owner, tapGestureRecognizer in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout-Related Methods
private extension CommunityDetailViewController {
    func adjustInputTextViewHeight() {
        guard let inputTextViewFont = inputTextView.font else { return }
        
        let maxLines = 4
        
        let maxHeight = inputTextViewFont.lineHeight * CGFloat(maxLines) // 최대 높이 계산
        let fittingSize = inputTextView.sizeThatFits(CGSize(width: inputTextView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = min(fittingSize.height, maxHeight) // 현재 높이와 최대 높이 비교
        inputTextView.flex.height(newHeight) // 높이 설정
        
        // 레이아웃 업데이트
        baseContainerView.flex.layout()
    }
    
    func updateLayout(_ marginBottom: CGFloat = 0) {
        baseContainerView.flex.define { flex in
            flex.addItem(collectionView).grow(1)
            flex.addItem(bottomContainerView).define { flex in
                flex.addItem(separatorView).height(1).marginBottom(8)
                flex.addItem(inputCommentContainerView).direction(.row).define { flex in
                    flex.addItem(inputTextView).width(0).grow(1).marginRight(16)
                    flex.addItem(sendCommentButton).size(24)
                }.alignItems(.center).padding(8, 16).marginHorizontal(24)
            }.marginBottom(marginBottom)
        }

        baseContainerView.flex.layout()
        
        baseContainerView.pin.all(view.pin.safeArea)
    }
}

// MARK: - ViewWillAppear Configuration Methods
private extension CommunityDetailViewController {
    func addNotificationCenterObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black

        let leftBarButtonItemImage = UIImage(resource: .icSignBack)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarButtonItemImage, style: .plain, target: self, action: #selector(leftBarButtonItemTapped))
        let rightBarButtonItemImage = UIImage(resource: .icMoreButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonItemImage, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    func configureTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - ViewWillDisappear Configuration Methods
private extension CommunityDetailViewController {
    func removeNotificationCenterObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - User Interaction Methods
private extension CommunityDetailViewController {
    @objc func leftBarButtonItemTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        let bottomInset = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?.safeAreaInsets.bottom ?? 0
        let updatedMarginBottom = view.frame.height - keyboardFrame.origin.y - bottomInset + 8 // 8pt 여백
        
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self else { return }
            updateLayout(updatedMarginBottom)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self else { return }
            updateLayout()
        }
    }
}
