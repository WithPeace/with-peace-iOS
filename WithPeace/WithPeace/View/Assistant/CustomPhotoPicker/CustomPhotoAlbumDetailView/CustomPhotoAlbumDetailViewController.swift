//
//  CustomPhotoAlbumDetailViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/20/24.
//

import UIKit
import Photos

final class CustomPhotoAlbumDetailViewController: UIViewController {
    
    var backButtonCompletionHandler: (([PHAsset]) -> ())?
    var completeCompletionHandler: (([PHAsset]) -> ())?
    
    private var toastMessage: ToastMessageView?
    private var albumCollection = PHCollection()
    private var dataSource: UICollectionViewDiffableDataSource<LayoutSection, PHAsset>?
    private var maxSelect: Int
    private var selectedAssets: [PHAsset] {
        didSet {
            let const = Const.CustomIcon.ICBtnPostcreate.self
            let count = selectedAssets.count
            if count > 0 {
                completeButton.setImage(UIImage(named: const.btnPostcreateDoneSelect), for: .normal)
                completeButton.isEnabled = true
                titleLabel.text = "\(count)/\(maxSelect)개 선택됨"
            } else {
                completeButton.setImage(UIImage(named: const.btnPostcreateDone), for: .normal)
                completeButton.isEnabled = false
                titleLabel.text = "\(count)/\(maxSelect)개 선택됨"
            }
        }
    }
    
    private let backButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        
        button.isEnabled = false
        button.setImage(UIImage(named: Const.CustomIcon.ICBtnPostcreate.btnPostcreateDone), for: .normal)
        
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .albumLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        
        configureLayout()
        registTarget()
        registeCollectionViewCell()
        configureDataSource()
        configureDataSourceSnapshot()
    }
    
    init( totalPhotoCount: Int, albumCollection: PHCollection, selectedAssets: [PHAsset]) {
        self.maxSelect = totalPhotoCount
        self.albumCollection = albumCollection
        self.selectedAssets = selectedAssets
        
        if selectedAssets.count > 0 {
            completeButton.isEnabled = true
            completeButton.setImage(UIImage(named: Const.CustomIcon.ICBtnPostcreate.btnPostcreateDoneSelect), for: .normal)
            titleLabel.text = "\(selectedAssets.count)/\(maxSelect)개 선택됨"
        }
        
        super.init(nibName: nil, bundle: nil)
        self.toastMessage = ToastMessageView(superView: self.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("DEINIT - CustomPhotoAlbumDetailViewController")
        backButtonCompletionHandler?(selectedAssets)
    }
}

//MARK: -Configure CollectionView
extension CustomPhotoAlbumDetailViewController {
    
    private func registeCollectionViewCell() {
        collectionView.register(AlbumDetailCell.self, forCellWithReuseIdentifier: AlbumDetailCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<LayoutSection, PHAsset>(collectionView: collectionView) { [weak self] collectionView, indexPath, identifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumDetailCell.identifier,
                                                                for: indexPath) as? AlbumDetailCell else {
                return UICollectionViewCell()
            }
            
            //TODO: TargetSize setting
            PHCachingImageManager().requestImage(for: identifier,
                                           targetSize: CGSize(width: 150, height: 150),
                                           contentMode: .aspectFill,
                                           options: nil) { image, _ in
                guard let image = image else { return }
                cell.setup(image: image)
            }
            guard let assets = self?.selectedAssets else { return UICollectionViewCell() }
            
            for selectedAsset in assets {
                if selectedAsset == self?.dataSource?.snapshot().itemIdentifiers[indexPath.row] {
                    cell.selectCell()
                }
            }
            return cell
        }
    }
    
    private func configureDataSourceSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<LayoutSection, PHAsset>()
        snapshot.appendSections([.DetailPhotos])
        
        let phFetchResult = PHAsset.fetchAssets(in: albumCollection as! PHAssetCollection, options: nil)
        
        for i in 0..<phFetchResult.count {
            let asset = phFetchResult.object(at: i)
            
            snapshot.appendItems([asset])
        }
        
        dataSource?.apply(snapshot)
    }
}

//MARK: - CollectionView Delegate
extension CustomPhotoAlbumDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //TODO: Check Cell
        guard let cell = collectionView.cellForItem(at: indexPath) as? AlbumDetailCell else { return }
        
        guard let dataSourceAssets = dataSource?.snapshot().itemIdentifiers else {
            return
        }
        
        for selectedAssetIndex in 0..<selectedAssets.count {
            if dataSourceAssets[indexPath.row] == selectedAssets[selectedAssetIndex] {
                selectedAssets.remove(at: selectedAssetIndex)
                cell.deselectCell()
                return
            }
        }
        
        if selectedAssets.count >= maxSelect {
            toastMessage?.presentStandardToastMessage("더 이상 이미지를 선택할 수 없습니다")
        } else {
            selectedAssets.append(dataSourceAssets[indexPath.row])
            cell.selectCell()
        }
    }
}

//MARK: -Configure Layout
extension CustomPhotoAlbumDetailViewController {
    
    private func configureLayout() {
        
        [backButton, titleLabel, completeButton, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: completeButton.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 24),
            titleLabel.bottomAnchor.constraint(equalTo: completeButton.bottomAnchor),
            
            completeButton.topAnchor.constraint(equalTo: backButton.topAnchor),
            completeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

//MARK: Target Method
extension CustomPhotoAlbumDetailViewController {
    
    private func registTarget() {
        backButton.addTarget(self, action: #selector(tabBackButton), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(tabCompleteButton), for: .touchUpInside)
    }
    
    @objc
    private func tabBackButton() {
        dismiss(animated: true) {
            self.backButtonCompletionHandler?(self.selectedAssets)
        }
    }
    
    @objc
    private func tabCompleteButton() {
        dismiss(animated: true) {
            self.completeCompletionHandler?(self.selectedAssets)
        }
    }
}
