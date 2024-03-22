//
//  DescriptionCell.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import UIKit
import RxSwift

final class DescriptionCell: UITableViewCell, UITextViewDelegate {
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 4, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "내용을 입력해주세요"
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var textChanged: PublishSubject<String> = PublishSubject()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleCell()
        setupNotification()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupTitleCell() {
        contentView.addSubview(descriptionTextView)
        descriptionTextView.addSubview(placeholderLabel)
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            placeholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor, constant: -4)
        ])
        
        updatePlaceholderVisibility()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged.onNext(textView.text)
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: KeyboardAction
extension DescriptionCell {
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil
        )
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.size.height
        descriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        descriptionTextView.scrollIndicatorInsets = descriptionTextView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        descriptionTextView.contentInset = .zero
        descriptionTextView.scrollIndicatorInsets = .zero
    }
}

extension DescriptionCell {
    enum Section {
        case main
    }
    
    struct Item: Hashable {
        let uuid = UUID()
        let image: UIImage
    }
    
    private func setupCollectionView() {
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 122)
        ])
        
        configureDataSource()
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(110))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(118), heightDimension: .absolute(110))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView)
        { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell",
                                                          for: indexPath) as? ImageCollectionViewCell
            cell?.configure(image: item.image)
            cell?.onDelete = {
                self.removeImage(indexPath: indexPath)
            }
            return cell
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems([], toSection: .main)
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    func addImages(_ images: [UIImage]) {
        var currentItems = dataSource.snapshot().itemIdentifiers(inSection: .main)
        let newItems = images.map { Item(image: $0) }
        currentItems.append(contentsOf: newItems)
        
        if currentItems.count > 5 {
            currentItems = Array(currentItems.prefix(5))
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(currentItems, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func removeImage(indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([item])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

final class ImageCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        
        return image
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btn-picture-delete"), for: .normal)
        button.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var onDelete: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -2),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
    
    @objc private func didTapDelete() {
        onDelete?()
    }
}
