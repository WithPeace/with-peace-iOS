//
//  CustomPhotoAlbumViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/18/24.
//

import UIKit
import Photos

final class CustomPhotoAlbumViewController: UIViewController {
    
    private var allPhotos = PHFetchResult<PHCollection>()
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
        
        configureLayout()
        registeCollectionViewCell()
        configureDataSource()
        configureDataSourceSnapshot()
    }
    
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
    
    private func registeCollectionViewCell() {
        collectionView.register(CustomAlbumCell.self, forCellWithReuseIdentifier: CustomAlbumCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<LayoutSection, PHCollection>(collectionView: collectionView) { collectionView, indexPath, identifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomAlbumCell.identifier, for: indexPath) as? CustomAlbumCell else {
                return UICollectionViewCell()
            }
            
            if let asset = PHAsset.fetchAssets(in: identifier as! PHAssetCollection, options: nil).firstObject {
                PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, hash in
                    if let image {
                        cell.setup(image: image)
                    }
                }
            }
            
            cell.setup(title: identifier.localizedTitle ?? "알 수 없는 앨범")
            cell.setup(count: PHAsset.fetchAssets(in: identifier as! PHAssetCollection, options: nil).count)
            
            return cell
        }
    }
    
    private func configureDataSourceSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<LayoutSection, PHCollection>()
        snapshot.appendSections([.defualt])
        
        //SMART ALBUMS
        smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .albumRegular,
            options: nil)
        
        var id = Array(repeating: PHCollection(), count: 2)
        
        for index in 0..<smartAlbums.count {
            let data = smartAlbums[index]
            
            guard let title = data.localizedTitle else { continue }
            
            switch title {
            case "Recents":
                id[0] = data
            case "Favorites":
                id[1] = data
            default:
                continue
            }
        }
        snapshot.appendItems(id)
        
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
