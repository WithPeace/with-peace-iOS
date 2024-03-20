//
//  CustomPhotoAlbumViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/18/24.
//

import UIKit
import Photos

final class CustomPhotoAlbumViewController: UIViewController {
    
    // 넘겨주고 받을 것
    var completionHandler: (([PHAsset]) -> ())?
    private var maxSelect: Int
    private var selectedAssets = [PHAsset]()
    
    private var smartAlbums = PHFetchResult<PHAssetCollection>()
    private var userCollections = PHFetchResult<PHAssetCollection>()
    private var dataSource: UICollectionViewDiffableDataSource<LayoutSection, PHCollection>?
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .defaultLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
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
        dataSource = UICollectionViewDiffableDataSource<LayoutSection, PHCollection>(collectionView: collectionView) { collectionView, indexPath, identifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomAlbumCell.identifier,
                                                                for: indexPath) as? CustomAlbumCell else {
                return UICollectionViewCell()
            }
            
            guard let assetCollection = identifier as? PHAssetCollection else {
                return UICollectionViewCell()
            }
            
            let targetSize = self.view.frame.width
            if let asset = PHAsset.fetchAssets(in: assetCollection, options: nil).firstObject {
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
            cell.setup(count: PHAsset.fetchAssets(in: assetCollection, options: nil).count)
            
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
        self.navigationController?.pushViewController(customDetailViewController ,animated: true)
        customDetailViewController.completionHandler = { [weak self] in
            self?.selectedAssets = $0
        }
    }
}

//MARK: -Configure Layout
extension CustomPhotoAlbumViewController {
    
    private func configureLayout() {
        view.addSubview(collectionView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
