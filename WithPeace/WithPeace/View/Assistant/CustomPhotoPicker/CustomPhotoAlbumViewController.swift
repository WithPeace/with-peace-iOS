//
//  CustomPhotoAlbumViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/18/24.
//

import UIKit
import Photos

final class CustomPhotoAlbumViewController: UIViewController {
    
    var completionHandlerPHAssets: (([PHAsset]) -> Void)?
    var completionHandlerChangePHAssetsToDatas: (([Data]) -> Void)?
    //TODO: completionHandlerChangePHAssetsToUIImage 네이밍 변경
    var completionHandler: (([UIImage]) -> Void)?
    
    private var maxSelect: Int
    private var selectedAssets = [PHAsset]()
    private var smartAlbums = PHFetchResult<PHAssetCollection>()
    private var userCollections = PHFetchResult<PHAssetCollection>()
    private var dataSource: UICollectionViewDiffableDataSource<LayoutSection, PHCollection>?
    
    private let backButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "사진첩"
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .defaultLayout)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        collectionView.delegate = self
        
        registTarget()
        configureLayout()
        registeCollectionViewCell()
        configureDataSource()
        configureDataSourceSnapshot()
    }
    
    init(maxSelect: Int) {
        self.maxSelect = maxSelect
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("DEINIT - CustomPhotoAlbumViewController")
    }
}

//MARK: -Configure CollectionView
extension CustomPhotoAlbumViewController {
    
    private func registeCollectionViewCell() {
        collectionView.register(CustomAlbumCell.self, forCellWithReuseIdentifier: CustomAlbumCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<LayoutSection, PHCollection>(collectionView: collectionView) { [weak self] collectionView, indexPath, identifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomAlbumCell.identifier,
                                                                for: indexPath) as? CustomAlbumCell else {
                return UICollectionViewCell()
            }
            
            guard let assetCollection = identifier as? PHAssetCollection else {
                return UICollectionViewCell()
            }
            
            guard let targetSize = self?.view.frame.width else { return UICollectionViewCell() }
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            
            if let asset = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions).lastObject {
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: CGSize(width: targetSize,
                                                                         height: targetSize),
                                                      contentMode: .aspectFit,
                                                      options: nil) { image, hash in
                    if let image {
                        cell.setup(image: image)
                    }
                }
            }
            
            cell.setup(title: identifier.localizedTitle ?? "알 수 없는 앨범")
            cell.setup(count: PHAsset.fetchAssets(in: assetCollection, options: fetchOptions).count)
            
            return cell
        }
    }
    
    private func configureDataSourceSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<LayoutSection, PHCollection>()
        snapshot.appendSections([.Album])
        
        //SMART ALBUMS
        smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .albumRegular,
            options: nil)
        
        for index in 0..<smartAlbums.count {
            let data = smartAlbums[index]
            guard let title = data.localizedTitle else { continue }
            
            if title == "Recents" {
                snapshot.appendItems([data])
            }
        }
        
        for index in 0..<smartAlbums.count {
            let data = smartAlbums[index]
            
            guard let title = data.localizedTitle else { continue }
            
            if title == "Favorites" {
                snapshot.appendItems([data])
            }
        }
        
        // USER COLLECTIONS
        userCollections = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: nil)
        
        for index in 0..<userCollections.count {
            let data = userCollections[index]
            
            snapshot.appendItems([data])
        }
        
        dataSource?.apply(snapshot)
    }
}

//MARK: - CollectionView Delegate
extension CustomPhotoAlbumViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Send PHCollection
        guard let snapshot = dataSource?.snapshot().itemIdentifiers else {
            fatalError()
        }
        
        let customDetailViewController = CustomPhotoAlbumDetailViewController(totalPhotoCount: maxSelect,
                                                                              albumCollection: snapshot[indexPath.row],
                                                                              selectedAssets: selectedAssets)
        customDetailViewController.modalPresentationStyle = .fullScreen
        self.present(customDetailViewController, animated: true)
        
        customDetailViewController.backButtonCompletionHandler = { [weak self] in
            self?.selectedAssets = $0
        }
        
        customDetailViewController.completeCompletionHandler = { [weak self] selectedAssets in
            self?.completionHandlerPHAssets?(selectedAssets)
            self?.convertAssetsToImages(assets: selectedAssets, completion: { images in
                self?.completionHandler?(images)
            })
            self?.dismiss(animated: true)
        }
    }
}

//MARK: -Configure Layout
extension CustomPhotoAlbumViewController {
    
    private func configureLayout() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        [backButton, titleLabel, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 24),
            
            backButton.heightAnchor.constraint(equalToConstant: 56),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
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
extension CustomPhotoAlbumViewController {
    
    private func registTarget() {
        backButton.addTarget(self, action: #selector(tabBackButton), for: .touchUpInside)
    }
    
    @objc
    private func tabBackButton() {
        dismiss(animated: true) {
            self.completionHandlerPHAssets?(self.selectedAssets)
        }
    }
    
    //???: 선택한 사진 순서대로 images에 append 된다는 것을 보장할 수 없지 않은가?
    private func convertAssetsToImages(assets: [PHAsset], completion: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        for asset in assets {
            let size = PHImageManagerMaximumSize
            imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { image, _ in
                if let image = image {
                    images.append(image)
                }
                
                if images.count == assets.count {
                    completion(images)
                }
            }
        }
    }
}
